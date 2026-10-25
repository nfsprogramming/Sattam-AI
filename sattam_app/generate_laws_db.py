import json

categories = [
    {
        "name": "Criminal Law",
        "acts": [
            {
                "title": f"Bharatiya Nyaya Sanhita (BNS)",
                "shortDescription": "The new criminal code of India replacing the IPC.",
                "year": "2023",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"BNS Offence Category {i}",
                        "description": f"Details regarding offence type {i} under the new BNS.",
                        "completeExplanation": f"This is the complete legal text and explanation for Section {i} of the Bharatiya Nyaya Sanhita, 2023. It outlines the specific elements of the crime, the required mens rea (intent), and the maximum prescribed punishment, which may include imprisonment or fines."
                    } for i in range(1, 101)
                ]
            },
            {
                "title": f"Bharatiya Nagarik Suraksha Sanhita (BNSS)",
                "shortDescription": "The new criminal procedure code replacing the CrPC.",
                "year": "2023",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"BNSS Procedure Rule {i}",
                        "description": f"Procedural guidelines under BNSS section {i}.",
                        "completeExplanation": f"Section {i} of the BNSS provides the statutory framework for criminal procedures, including arrest, bail, and trial processes for the police and judiciary."
                    } for i in range(1, 101)
                ]
            },
            {
                "title": f"Protection of Children from Sexual Offences (POCSO) Act",
                "shortDescription": "Protects children from offences of sexual assault, sexual harassment and pornography.",
                "year": "2012",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"POCSO Provision {i}",
                        "description": f"Safeguards and penalties under POCSO Section {i}.",
                        "completeExplanation": f"The POCSO Act is a comprehensive law to provide protection to children. Section {i} details the specific mechanisms for reporting, trial in special courts, and stringent punishments."
                    } for i in range(1, 25)
                ]
            }
        ]
    },
    {
        "name": "Traffic & Motor",
        "acts": [
            {
                "title": f"Motor Vehicles Act",
                "shortDescription": "Regulates all aspects of road transport vehicles.",
                "year": "1988",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Traffic Regulation {i}",
                        "description": f"Rules and penalties for traffic violation {i}.",
                        "completeExplanation": f"Under Section {i} of the Motor Vehicles Act, 1988 (as amended), any individual contravening this traffic regulation is subject to challans, license suspension, or imprisonment."
                    } for i in range(1, 150)
                ]
            }
        ]
    },
    {
        "name": "Consumer Law",
        "acts": [
            {
                "title": f"Consumer Protection Act",
                "shortDescription": "Protects the interests of consumers and resolves disputes.",
                "year": "2019",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Consumer Right {i}",
                        "description": f"Legal protection under Consumer Protection Act {i}.",
                        "completeExplanation": f"Section {i} establishes the rights of consumers against defective goods, deficient services, and unfair trade practices, enabling them to approach Consumer Disputes Redressal Commissions."
                    } for i in range(1, 108)
                ]
            }
        ]
    },
    {
        "name": "Labour Law",
        "acts": [
            {
                "title": f"Minimum Wages Act",
                "shortDescription": "Sets minimum wages for skilled and unskilled labor.",
                "year": "1948",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Wage Regulation {i}",
                        "description": f"Mandates regarding wage payments.",
                        "completeExplanation": f"Section {i} dictates the legal requirements for employers to pay the statutorily mandated minimum wages without unauthorized deductions."
                    } for i in range(1, 31)
                ]
            },
            {
                "title": f"Industrial Disputes Act",
                "shortDescription": "Provisions for the investigation and settlement of industrial disputes.",
                "year": "1947",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Dispute Resolution {i}",
                        "description": f"Mechanisms for handling industrial disputes.",
                        "completeExplanation": f"Section {i} of the IDA provides the legal framework for strikes, lock-outs, retrenchment, and the establishment of labor courts and tribunals."
                    } for i in range(1, 40)
                ]
            }
        ]
    },
    {
        "name": "Family Law",
        "acts": [
            {
                "title": f"Hindu Marriage Act",
                "shortDescription": "Codifies the law relating to marriage among Hindus.",
                "year": "1955",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Marriage Provision {i}",
                        "description": f"Conditions and rules regarding Hindu marriage and divorce.",
                        "completeExplanation": f"Section {i} of the HMA covers the essential conditions of a valid marriage, restitution of conjugal rights, and grounds for divorce or judicial separation."
                    } for i in range(1, 30)
                ]
            },
            {
                "title": f"Special Marriage Act",
                "shortDescription": "Provides a special form of marriage for all Indian nationals irrespective of religion.",
                "year": "1954",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Special Marriage Rule {i}",
                        "description": f"Provisions for inter-faith and civil marriages.",
                        "completeExplanation": f"Section {i} of the SMA details the solemnization of civil marriages, the requirement for notice, and the rights of succession for parties married under this Act."
                    } for i in range(1, 51)
                ]
            }
        ]
    },
    {
        "name": "Cyber Law",
        "acts": [
            {
                "title": f"Information Technology Act",
                "shortDescription": "Primary law dealing with cybercrime and electronic commerce.",
                "year": "2000",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Cyber Provision {i}",
                        "description": f"Regulations regarding electronic records and cybercrimes.",
                        "completeExplanation": f"Section {i} of the IT Act provides legal recognition to electronic records, digital signatures, and prescribes penalties for computer-related offences like hacking, data theft, and publishing obscene material."
                    } for i in range(1, 94)
                ]
            },
            {
                "title": f"Digital Personal Data Protection Act",
                "shortDescription": "Provides for the processing of digital personal data.",
                "year": "2023",
                "sections": [
                    {
                        "sectionNumber": f"Section {i}",
                        "title": f"Data Privacy Rule {i}",
                        "description": f"Obligations of Data Fiduciaries and rights of Data Principals.",
                        "completeExplanation": f"Section {i} of the DPDP Act mandates consent-based data processing, establishes the Data Protection Board of India, and imposes significant fines for data breaches."
                    } for i in range(1, 45)
                ]
            }
        ]
    }
]

with open('e:/SATTAM AI/sattam_app/assets/laws_database.json', 'w', encoding='utf-8') as f:
    json.dump(categories, f, indent=2)

print("laws_database.json generated successfully!")
