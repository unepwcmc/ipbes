# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Admin user
decioferreira = User.create(email: 'decio.ferreira@unep-wcmc.org', password: 'decioferreira', password_confirmation: 'decioferreira')
decioferreira.update_attribute(:approved, true)
decioferreira.update_attribute(:admin, true)

# Assessment
assessment = Assessment.create(title: 'United Kingdom National Ecosystem Assessment', short_title: 'UK NEA', published: true)

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

#assessment.answers.create(answer_type: 'communication_materials', text_value: 'National')

#assessment.answers.create(answer_type: 'geo_scale', text_value: 'National')
#assessment.answers.create(answer_type: 'geo_scale', text_value: 'National')
#assessment.answers.create(answer_type: 'geo_scale', text_value: 'National')
#assessment.answers.create(answer_type: 'geo_scale', text_value: 'National')
#assessment.answers.create(answer_type: 'geo_scale', text_value: 'National')
