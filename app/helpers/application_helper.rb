module ApplicationHelper

    def avatar_url(user)
        if user.profilepic.attached?
            url_for(user.profilepic)
        elsif user.image?
            user.image
        else
            ActionController::Base.helpers.asset_path('default_profile_pic.jpg')
        end
    end

    def cover_url(category)
        if category.cover.attached?
            url_for(category.cover)
        else
            ActionController::Base.helpers.asset_path('default_category_pic.jpg')
        end
    end
    
    # Site configuration (disclaimer, tel, mail, etc)
    def siteinfo
        if Rails.configuration.siteinfos.empty?
            Rails.configuration.siteinfos = Hash[SiteInfo.all.map { |u| [u.key, u] }]
        else
            Rails.configuration.siteinfos
        end
    end

    # Site Admins
    def admins
        User.where(:usertype => User.usertypes[:admin])
    end

    # Temporary Products list
    def products
        [
           { 
            :id    => 'd4a8891e-acf9-4cab-8562-53eb6c77e055',
            :type => 'subscriptions',
            :title => "Abbonamento Basic (1 anno)",
            :description => "Abbonamento con accesso Base per 1 anno ai servizi AVQ riservati ai professionisti <br /><em><strong>Include 50 Crediti gratuiti <sup>(*)</sup></strong></em>",
            :timespan => "1-year",
            :price => 69.90,
            :image => "special/special_offer_02.png",
            :more_link => account_product_modal_url('d4a8891e-acf9-4cab-8562-53eb6c77e055'),
            :discount => 0,
            :subscription => 0,
            :credits => 50
           },
           { 
            :id    => '80255e51-8d3b-49c0-b0e1-b461476572da',
            :type => 'late_subscriptions',
            :title => "Abbonamento Basic (1 anno)",
            :description => "Abbonamento con accesso Base per 1 anno ai servizi AVQ riservati ai professionisti",
            :timespan => "1-year",
            :price => 69.90,
            :image => "special/best_offer.jpg",
            :more_link => account_product_modal_url('80255e51-8d3b-49c0-b0e1-b461476572da'),
            :discount => 0,
            :subscription => 0,
            :credits => 0
           },
           { 
            :id    => 'ca19847c-1595-4570-821e-d2a833d97e0a',
            :type => 'subscriptions',
            :title => "Abbonamento Premium (1 anno)",
            :description => "Abbonamento con accesso Premium <strong>All-Inclusive</strong> per 1 anno ai servizi AVQ riservati ai professionisti<p>&nbsp;</p>",
            :timespan => "1-year",
            :price => 399.90,
            :image => "special/best_offer.jpg",
            :more_link => account_product_modal_url('ca19847c-1595-4570-821e-d2a833d97e0a'),
            :discount => 0,
            :subscription => 1,
            :credits => 0
           },
           { 
            :id    => 'f8350e12-682e-4284-a974-477d755751da',
            :type => 'upgrades',
            :title => "Upgrade Abbonamento da Basic a Premium",
            :description => "Upgrade abbonamento da Basic ad accesso Premium <strong>All-Inclusive</strong> per 1 anno ai servizi AVQ riservati ai professionisti<br /><br />Sei già un utente Basic e desideri trasformare il tuo profilo in <strong>Premium</strong>?
Avq ti dà la possibilità di fare un upgrade del tuo abbonamento per ottenere maggiore visibilita’ e contatti diretti, scalandoti  dal prezzo dell'Abbonamento Premium il costo già sostenuto in fase di registrazione iniziale",
            :timespan => "1-year",
            :price => 330.00,
            :image => "special/special_offer_03.png",            
            :discount => 0,
            :subscription => 1,
            :credits => 0
           },           
           {
            :id    => '4c53f446-84c4-77fd-fcbd-464039e2ced9',
            :type => 'credits_offer',
            :title => "Offerta 140 crediti",
            :description => "Pacchetto offerta di 140 crediti",
            :image => "special/special_offer_03.png",
            :price => 129.90,
            :discount => -20,
            :credits => 140
           },
           {
            :id    => 'ad202f98-2ab7-5f91-ed18-a45665acf253',
            :type => 'credits_offer',
            :title => "Offerta 210 crediti",
            :description => "Pacchetto offerta di 210 crediti",
            :image => "special/special_offer_03.png",
            :price => 159.90,
            :discount => -30,
            :credits => 210            
           },
           {
            :id    => '4922d1b9-d4c5-442b-a273-f9a7525a26b2',
            :type => 'credits',
            :title => "Pacchetto 70 crediti",
            :description => "Pacchetto di 70 crediti",
            :price => 89.90,
            :discount => 0,
            :credits => 70
           },
           {
            :id    => 'a20a9c38-2d1e-4417-8e68-46930b1c3689',
            :type => 'credits',
            :title => "Pacchetto 140 crediti",
            :description => "Pacchetto di 140 crediti",
            :price => 129.90,
            :discount => 0,
            :credits => 140            
           },
           {
            :id    => '9f0b6d20-ccd4-4d0d-83b9-011c44127638',
            :type => 'credits',
            :title => "Pacchetto 210 crediti",
            :description => "Pacchetto di 210 crediti",
            :price => 159.90,
            :discount => 0,
            :credits => 210            
           }

        ]
    end

    def bkimages
        [
            'consulenza.jpg',
            'decoratore.jpg',
            'edilizia.jpg',
            'edilizia1.jpg',
            'elettricista.jpg',
            'elettricista1.jpg',
            'elettricista2.jpg',
            'fabbro.jpg',
            'fabbro1.jpg',
            'ferramenta.jpg',
            'fisioterapia.jpg',
            'idraulica.jpg',
            'medicina.jpg',
            'medicina2.jpg',
            'medicina3.jpg',
            'ristrutturazione.jpg',
            'salute-mentale.png'
        ]
    end    

end
