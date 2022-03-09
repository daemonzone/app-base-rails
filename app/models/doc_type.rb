class DocType

  def self.types
  	['ci_f', 'ci_r', 'ci_fr', 'cf_f', 'cf_r', 'cf_fr', 'vc']
  end

  def self.full_types
	{
        :ci_f => ['Carta Identità (fronte)', 		'ci_f', 	'ci', 1],
        :ci_r => ['Carta Identità (retro)', 		'ci_r',		'ci', 1],
        :ci_fr => ['Carta Identità (fronte/retro)', 'ci_fr', 	'ci', 2],

        :cf_f => ['Codice Fiscale (fronte)', 		'cf_f', 	'cf', 1],
        :cf_r => ['Codice Fiscale (retro)', 		'cf_r', 	'cf', 1],
        :cf_fr => ['Codice Fiscale (fronte/retro)', 'cf_fr', 	'cf', 2],
        
        :vc => ['Visura Camerale', 'vc', 'vc', 1]
    }    
  end

end

# DocType.full_types.select{|k| DocType.types.include? k } 