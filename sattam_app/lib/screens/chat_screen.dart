import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'generate_document_screen.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_panel.dart';
import '../services/supabase_service.dart';

class ChatMessage {
  final String role;
  String content;
  bool isStreaming;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    this.isStreaming = false,
  }) : timestamp = DateTime.now();
}

class ChatScreen extends StatefulWidget {
  final String? initialQuery;
  final VoidCallback? onBackTap;
  const ChatScreen({super.key, this.initialQuery, this.onBackTap});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _cancelStream = false;
  String? _sessionId;

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  static const String _apiBase = 'https://sattam-ai-qr4d.onrender.com';

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
  final List<Map<String, String>> _quickChips = [
    {'label': 'Unpaid Salary 💰', 'query': 'What are my rights if my employer refuses to pay my salary?'},
    {'label': 'Rent Dispute 🏠', 'query': 'My landlord is refusing to return my security deposit. What can I do?'},
    {'label': 'Police FIR 👮', 'query': 'How do I file a police FIR and what are my rights during arrest?'},
    {'label': 'Document Review 📄', 'query': 'What documents do I need for a property purchase in India?'},
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.initialQuery!;
        _sendMessage();
      });
    }
  }

  /// Called by MainScreen to send a query from the home search bar
  void sendExternalQuery(String query) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.text = query;
      _sendMessage();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSession(String sessionId) async {
    setState(() => _isLoading = true);
    try {
      final history = await SupabaseService.getMessages(sessionId);
      setState(() {
        _sessionId = sessionId;
        _messages.clear();
        for (var msg in history) {
          _messages.add(ChatMessage(role: msg['role'], content: msg['content']));
        }
        _listKey = GlobalKey<AnimatedListState>();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      // ignore
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startNewChat() {
    setState(() {
      _sessionId = null;
      _messages.clear();
      _listKey = GlobalKey<AnimatedListState>();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage([String? quickText]) async {
    final text = quickText ?? _controller.text.trim();
    if ((text.isEmpty && _selectedImage == null) || _isLoading) return;

    if (_sessionId == null) {
      try {
        _sessionId = await SupabaseService.createChatSession(
          title: text.length > 30 ? '${text.substring(0, 30)}...' : text
        );
      } catch (_) {}
    }

    _controller.clear();
    _focusNode.unfocus();
    
    _messages.add(ChatMessage(role: 'user', content: text));
    _listKey.currentState?.insertItem(_messages.length - 1, duration: const Duration(milliseconds: 350));
    
    if (_sessionId != null) {
      SupabaseService.saveMessage(sessionId: _sessionId!, role: 'user', content: text).catchError((_) {});
    }
    
    setState(() {
      _isLoading = true;
      _cancelStream = false;
    });
    _scrollToBottom();

    final aiMessage = ChatMessage(role: 'ai', content: '', isStreaming: true);
    _messages.add(aiMessage);
    _listKey.currentState?.insertItem(_messages.length - 1, duration: const Duration(milliseconds: 350));
    setState(() {});

    try {
      final request = http.Request('POST', Uri.parse('$_apiBase/chat/stream'));
      request.headers['Content-Type'] = 'application/json';
      String? base64Image;
      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      final historyList = _messages.take(_messages.length - 2).map((m) => {
        'role': m.role == 'user' ? 'user' : 'assistant',
        'content': m.content,
      }).toList();

      final requestBody = {
        'query': text,
        'history': historyList,
      };
      
      if (base64Image != null) {
        requestBody['base64_image'] = base64Image;
      }

      request.body = jsonEncode(requestBody);
      
      setState(() {
        _selectedImage = null;
      });

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
        onTimeout: () =>
            throw Exception('Cannot connect to server. Make sure the FastAPI server is running at $_apiBase'),
      );

      if (streamedResponse.statusCode != 200) {
        setState(() {
          aiMessage.content = 'Server error: ${streamedResponse.statusCode}';
          aiMessage.isStreaming = false;
          _isLoading = false;
        });
        return;
      }

      await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
        if (_cancelStream) break;
        
        for (final line in chunk.split('\n')) {
          if (_cancelStream) break;
          
          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6).trim();
            if (jsonStr.isEmpty) continue;
            try {
              final data = jsonDecode(jsonStr);
              if (data['done'] == true) {
                setState(() {
                  aiMessage.isStreaming = false;
                  _isLoading = false;
                });
              } else if (data['error'] != null) {
                setState(() {
                  aiMessage.content += '\n\n*Error: ${data['error']}*';
                  aiMessage.isStreaming = false;
                  _isLoading = false;
                });
              } else if (data['token'] != null) {
                setState(() => aiMessage.content += data['token'] as String);
                _scrollToBottom();
              }
            } catch (_) {}
          }
        }
      }

      if (_cancelStream) {
        setState(() {
          if (aiMessage.content.isNotEmpty) {
            aiMessage.content += '\n\n';
          }
          aiMessage.content += '*[Operation cancelled by user]*';
        });
      }

      setState(() {
        aiMessage.isStreaming = false;
        _isLoading = false;
      });
      
      if (_sessionId != null && aiMessage.content.isNotEmpty) {
        SupabaseService.saveMessage(sessionId: _sessionId!, role: 'ai', content: aiMessage.content).catchError((_) {});
      }
    } catch (e) {
      setState(() {
        aiMessage.content = '**Connection failed**\n\n${e.toString()}\n\nMake sure the FastAPI server is running.';
        aiMessage.isStreaming = false;
        _isLoading = false;
      });
      if (_sessionId != null) {
        SupabaseService.saveMessage(sessionId: _sessionId!, role: 'ai', content: aiMessage.content).catchError((_) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      endDrawer: _buildHistoryDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty ? _buildEmptyState() : _buildMessageList(),
          ),
          if (_messages.isNotEmpty && !_isLoading) _buildSuggestionChips(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHistoryDrawer() {
    return Drawer(
      backgroundColor: context.colors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chat History', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: context.colors.borderSubtle),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: SupabaseService.getChatSessions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: context.colors.primary));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No past conversations', style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted)),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final session = snapshot.data![index];
                      final isActive = session['id'] == _sessionId;
                      return ListTile(
                        leading: Icon(Icons.chat_bubble_outline_rounded, color: context.colors.textMuted, size: 20),
                        title: Text(
                          session['title'] ?? 'New Conversation',
                          style: GoogleFonts.plusJakartaSans(
                            color: isActive ? context.colors.primary : context.colors.textPrimary,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        tileColor: isActive ? context.colors.primary.withValues(alpha: 0.1) : Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          _loadSession(session['id']);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: context.colors.bgBase,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
        onPressed: () {
          if (widget.onBackTap != null) {
            widget.onBackTap!();
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Ask AI',
        style: GoogleFonts.plusJakartaSans(
          color: context.colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add_rounded, color: context.colors.textPrimary),
          tooltip: 'New Chat',
          onPressed: _startNewChat,
        ),
        Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.history_rounded, color: context.colors.textPrimary),
            tooltip: 'Chat History',
            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: context.colors.borderSubtle),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildChip('Yes, generate'),
          const SizedBox(width: 8),
          _buildChip('Explain relevant laws'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return ActionChip(
      onPressed: () {
        if (label == 'Yes, generate') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GenerateDocumentScreen(),
            ),
          );
        } else {
          _controller.text = label;
          _sendMessage();
        }
      },
      backgroundColor: context.colors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: context.colors.primary.withValues(alpha: 0.3)),
      ),
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: context.colors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.colors.primaryContainer.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.smart_toy_rounded, color: context.colors.primary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Legal Guidance in Every Tongue',
            style: GoogleFonts.instrumentSerif(
              color: context.colors.textPrimary,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me about Labour Law, Property, or\nFamily disputes. I speak English and தமிழ்.',
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textMuted,
              fontSize: 13,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _quickChips.map((chip) {
              return GestureDetector(
                onTap: () => _sendMessage(chip['query']),
                child: GlassPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  borderRadius: BorderRadius.circular(50),
                  child: Text(
                    chip['label']!,
                    style: GoogleFonts.plusJakartaSans(
                      color: context.colors.textOnSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return AnimatedList(
      key: _listKey,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      initialItemCount: _messages.length,
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          alignment: Alignment.bottomCenter,
          child: FadeTransition(
            opacity: animation,
            child: _buildBubble(_messages[index]),
          ),
        );
      },
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    final isUser = msg.role == 'user';
    final timeStr =
        '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')} ${msg.timestamp.hour >= 12 ? 'PM' : 'AM'}';

    if (isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.82),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2468FF), Color(0xFF0D40CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primaryContainer.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Text(
                msg.content,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(timeStr,
                style: TextStyle(
                    color: context.colors.textMuted, fontSize: 10)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.92),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.borderStrong),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SattamAI Avatar Header
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.balance_rounded, color: context.colors.secondary, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SattamAI',
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down_rounded, color: context.colors.textMuted, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Content
                  if (msg.content.isEmpty && msg.isStreaming)
                    const _TypingDots()
                  else
                    MarkdownBody(
                      data: msg.content,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.plusJakartaSans(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          height: 1.7,
                        ),
                        h2: GoogleFonts.plusJakartaSans(
                          color: context.colors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 2.2,
                        ),
                        h3: GoogleFonts.plusJakartaSans(
                          color: context.colors.secondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 2.0,
                        ),
                        strong: GoogleFonts.plusJakartaSans(
                          color: context.colors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                        em: GoogleFonts.plusJakartaSans(
                          color: context.colors.textMuted,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                        listBullet: TextStyle(color: context.colors.primary),
                        blockquotePadding: const EdgeInsets.all(10),
                        blockquoteDecoration: BoxDecoration(
                          color: context.colors.surfaceContainer,
                          border: Border(
                            left: BorderSide(color: context.colors.primaryContainer, width: 3),
                          ),
                        ),
                      ),
                    ),
                  if (msg.isStreaming && msg.content.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const _TypingDots(),
                  ],
                  const SizedBox(height: 12),
                  // Timestamp
                  if (!msg.isStreaming)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '9:30 AM',
                              style: GoogleFonts.plusJakartaSans(
                                color: context.colors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.done_all_rounded, color: context.colors.textMuted, size: 12),
                          ],
                        ),
                      ),
                    ),
                  // Actions bar (only when complete)
                  if (!msg.isStreaming && msg.content.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          _ActionBtn(
                            icon: Icons.bookmark_border_rounded,
                            label: 'Save',
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _ActionBtn(
                            icon: Icons.content_copy_rounded,
                            label: 'Copy',
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: msg.content));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Copied to clipboard'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: context.colors.surfaceContainerHigh,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          _ActionBtn(
                            icon: Icons.insights_rounded,
                            label: 'Analyze',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'SattamAI • $timeStr',
            style: TextStyle(color: context.colors.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'Attachment Menu',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: 260,
            margin: EdgeInsets.only(left: 16, bottom: bottomInset + 85),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF383838), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPopupItem(
                    icon: Icons.attach_file_rounded,
                    title: 'Add photos & files',
                    subtitle: 'Upload from device',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  _buildPopupItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'Take a photo',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation, 
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return Transform.scale(
          scale: 0.95 + (0.05 * curvedAnimation.value),
          alignment: const Alignment(-0.8, 1.0), // Anchors scale effect near the + button
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildPopupItem({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF383838),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8A8A8A),
                        fontSize: 13,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _stopGeneration() {
    setState(() {
      _cancelStream = true;
      _isLoading = false;
    });
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colors.bgBase.withValues(alpha: 0.0),
            context.colors.bgBase,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), 
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF2F2F2F), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8, left: 8),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImage!, height: 60, width: 60, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: -10,
                            top: -10,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Circular + button
                      GestureDetector(
                        onTap: _showAttachmentMenu,
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      // Text field
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            cursorColor: const Color(0xFF6EA8FE),
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ask anything',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF8A8A8A),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 9),
                            ),
                            maxLines: 8,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                      ),
                      // Send / Stop
                      Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: _isLoading 
                              ? _stopGeneration 
                              : (_controller.text.trim().isEmpty && _selectedImage == null ? null : () => _sendMessage()),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _isLoading 
                              ? Colors.transparent 
                              : (_controller.text.trim().isEmpty 
                                  ? Colors.transparent 
                                  : Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: _isLoading
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF8FAEFF),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8FAEFF),
                                        borderRadius: BorderRadius.circular(1.5),
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  Icons.arrow_upward_rounded,
                                  color: _controller.text.trim().isEmpty ? const Color(0xFF8FAEFF) : Colors.black, 
                                  size: 20,
                                ),
                        ), // Center
                      ), // AnimatedContainer
                    ), // GestureDetector
                  ), // Container
                ], // Row children
              ), // Row
            ], // Column children
          ), // Column
        ), // Container
      ), // ConstrainedBox
    ), // Center
  ), // SafeArea
); // Container
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: context.colors.textMuted, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: context.colors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final t = (_ctrl.value - i * 0.15).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.only(right: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.3 + t * 0.7),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
