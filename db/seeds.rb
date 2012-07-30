# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Admin user
decioferreira = User.create(name: 'Decio Ferreira', email: 'decio.ferreira@unep-wcmc.org', password: 'decioferreira', password_confirmation: 'decioferreira')
decioferreira.update_attribute(:approved, true)
decioferreira.update_attribute(:admin, true)

# Assessment
assessment = Assessment.create(title: 'United Kingdom National Ecosystem Assessment', short_title: 'UK NEA', note: '', published: true)

assessment.answers.create(answer_type: 'geo_scale', text_value: 'National')
assessment.answers.create(answer_type: 'geo_countries', text_value: Country.find_by_name('United Kingdom').id)
assessment.answers.create(answer_type: 'geo_info', text_value: 'The assessment covered England, Northern Ireland, Wales & Scotland')

assessment.answers.create(answer_type: 'objectives', text_value: "To produce an independent and peer-reviewed UK National Ecosystem Assessment for the whole of the UK.\nTo raise awareness of the importance of the natural environment to human well-being and economic prosperity.\nTo ensure full stakeholder participation and encourage different stakeholders and communities to interact and, in particular, to foster better inter-disciplinary cooperation between natural and social scientists, as well as economists.")
assessment.answers.create(answer_type: 'mandate', text_value: 'Following the Millennium Ecosystem Assessment (MA), the House of Commons Environmental Audit recommended the Government conduct an ecosystem assessment for the UK to enable the identification and development of effective policy responses to ecosystem service degradation.')
assessment.answers.create(answer_type: 'conceptual_framework', text_value: 'Millennium Ecosystem Assessment (MA)')
assessment.answers.create(answer_type: 'conceptual_framework_url', text_value: "1 attachment:\nMace, G.M et al. (2011) Conceptual Framework and Methodology. In: The UK National Ecosystem Assessment Technical Report. UK National Ecosystem Assessment, UNEP-WCMC, Cambridge.\n\nBateman, I.J., Mace, G.M., Fezzi, C., Atkinson, G. & Turner, K. (2011) Economic analysis for ecosystem service assessments. Environmental and resource economics, 48 (2). pp. 177-218. ISSN 0924-6460.")
assessment.answers.create(answer_type: 'systems_assessed', text_value: 'Marine,Coastal,Inland water,Forest and woodland,Cultivated/Agricultural land,Grassland,Mountain,Urban')
assessment.answers.create(answer_type: 'species_groups_assessed', text_value: 'Birds, fish, mammals')
assessment.answers.create(answer_type: 'provisioning', text_value: 'Food,Water,Timber/fibres,Genetic resources,Medicinal resources,Ornamental resources')
assessment.answers.create(answer_type: 'regulating', text_value: 'Air quality,Climate regulation,Moderation of extreme events,Regulation of water flows,Regulation of water quality,Waste treatment,Erosion prevention,Pollination,Pest and disease control')
assessment.answers.create(answer_type: 'supporting', text_value: 'Habitat maintenance,Nutrient cycling,Soil formation and fertility,Primary production')
assessment.answers.create(answer_type: 'cultural_services', text_value: 'Recreation and tourism,Spiritual, inspiration and cognitive development,Sense of place')

assessment.answers.create(answer_type: 'scope_drivers_of_change', text_value: 'Yes')
assessment.answers.create(answer_type: 'scope_impacts_of_change', text_value: 'Yes')
assessment.answers.create(answer_type: 'scope_options_for_responding', text_value: 'Yes')
assessment.answers.create(answer_type: 'scope_explicit_consideration', text_value: 'Yes')

assessment.answers.create(answer_type: 'year_started', text_value: '2009')
assessment.answers.create(answer_type: 'year_finished', text_value: '2011')
#assessment.answers.create(answer_type: 'anticipated_to_finish', text_value: '2012')
assessment.answers.create(answer_type: 'periodicity', text_value: 'One off')
#assessment.answers.create(answer_type: 'how_frequently', text_value: 'Yearly')

assessment.answers.create(answer_type: 'websites', text_value: 'http://uknea.unep-wcmc.org/')
assessment.answers.create(answer_type: 'reports', text_value: "UK National Ecosystem Assessment (2011) The UK National Ecosystem Assessment: Synthesis of the Key Findings. UNEP-WCMC, Cambridge.\n\nUK National Ecosystem Assessment (2011) The UK National Ecosystem Assessment: Technical Report. UNEP-WCMC, Cambridge.\n\nhttp://uknea.unep-wcmc.org/Resources/tabid/82/Default.aspx")
assessment.answers.create(answer_type: 'communication_materials', text_value: "Brochure\nUK National Ecosystem Assessment (2010) Progress and steps towards delivery. UNEP-WCMC, Cambridge\nhttp://uknea.unep-wcmc.org/Resources/tabid/82/Default.aspx\n\nPresentation / poster/ postcard downloadable from http://uknea.unep-wcmc.org/Resources/NEACommunications/tabid/105/Default.aspx")
assessment.answers.create(answer_type: 'journal_publications', text_value: "Watson, R.T. The science-policy interface: the role of scientific assessments-UK National Ecosystem Assessment. Proceedings of the Royal Society A. Available online 5 July.\n\nFirbank, L., Bradbury, R.B., McCracken, D.I. & Stoate, C. Delivering multiple ecosystem services from Enclosed Farmland in the UK. Agriculture, Ecosystems & Environment. Available online 17 February 2012.\n\nMace, G.M., Norris, K. & Fitter, A.H. Biodiversity and ecosystem services: a multilayered relationship. Trends in Ecology & Evolution, Volume 27, Issue 1, 19-26, 22 September 2011.")
assessment.answers.create(answer_type: 'training_materials', text_value: 'N/A')
assessment.answers.create(answer_type: 'other_documents', text_value: 'N/A')
assessment.answers.create(answer_type: 'tools_and_approaches', text_value: 'Modelling,Geospatial analysis,Indicators,Scenarios,Economic valuation,Social (non-monetary) valuation')
assessment.answers.create(answer_type: 'process_used_for_stakeholder', text_value: 'Selected 20 member User Group.\nCountry-level stakeholder meetings as part of the Scenarios development.\nWider stakeholder meetings to review outputs.')
assessment.answers.create(answer_type: 'key_stakeholder', text_value: 'Environment Agency,Natural England')
assessment.answers.create(answer_type: 'number_of_people', text_value: '100-1000')
assessment.answers.create(answer_type: 'incorporation_of_knowledge', text_value: 'Scientific information only')
assessment.answers.create(answer_type: 'supporting_documentation', text_value: 'Bateman, I.J., Mace, G.M., Fezzi, C., Atkinson, G. & Turner, K. (2011) Economic analysis for ecosystem service assessments. Environmental and resource economics, 48 (2). pp. 177-218. ISSN 0924-6460.')
assessment.answers.create(answer_type: 'reports_peer', text_value: 'Yes')
assessment.answers.create(answer_type: 'accessibility_of_data', text_value: 'Mixed some in public domain, some required a paid license')
assessment.answers.create(answer_type: 'impacts', text_value: 'Provided the evidence to underpin the Natural Environment White Paper published in 2011.')
assessment.answers.create(answer_type: 'review_on_policy', text_value: 'Yes')
assessment.answers.create(answer_type: 'lessons_learnt', text_value: 'A strong conceptual framework can be a useful communication tool to engage other government departments')
assessment.answers.create(answer_type: 'capacity_building_needs', text_value: 'None')
assessment.answers.create(answer_type: 'actions_taken_build_capacity', text_value: 'Network and sharing experiences,Access to funding,Sharing of data/repatriation of data,Workshops,Developing/promoting and providing access to support tools,Establishing common standards, methods and protocols,Communication and awareness raising')
assessment.answers.create(answer_type: 'gaps_in_capacity', text_value: 'To be discussed')
assessment.answers.create(answer_type: 'gaps_in_knowledge', text_value: 'Understanding of cultural, shared and multiple values')
assessment.answers.create(answer_type: 'gaps_in_knowledge_communicated', text_value: 'Additional research funded in UK NEA follow-on project')
assessment.answers.create(answer_type: 'additional_information', text_value: '')

assessment.contacts.create(name: 'Joe Bloggs', title: 'Dr', email: 'Joe.bloggs@defra.gov.uk', phone: '01234 567893', organisation: 'Defra', organisation_address: 'Defra, London')
