class Document < ApplicationRecord

  enum status: [:attesa_verifica, :approvato, :non_conforme]
  
  has_one_attached :attachment

end
