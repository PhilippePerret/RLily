require "spec_helper"


describe "Fonctions" do
  
  
  describe "#hidden_elements" do
    it 'répond' do
      expect{hidden_elements :all, {except: []}}.to_not raise_error
    end
    it 'retourne la clé seule si c’est une clé seule' do
      expect(hidden_elements :stem, {except: []}).to eq([:stem])
    end
    it 'retourne la liste de clé si c’est une liste de clés' do
      expect(hidden_elements [:stem, :beam], {except: []}).to eq([:stem, :beam])
    end
    it 'retourne la clé anglaise si c’est une clé française' do
      expect(hidden_elements :liaison, {except: []}).to eq([:slur])
    end
    it 'retourne la liste de clés anglais avec un liste anglaise/française' do
      expect(hidden_elements [:hampe, :beam, :tete], {except: []}).to eq([:stem, :beam, :head])
    end
    it 'retourne toutes les clés si :all' do
      liste_cles = DATA_HIDE.collect do |k, v| 
        next nil unless v[:with_all]
        k 
      end.reject{|e| e.nil?}
      expect(hidden_elements :all, {except: []}).to eq(liste_cles)
    end
    it 'retourne toutes les clés sauf les clés exclues' do
      liste_cles = DATA_HIDE.collect do |k, v| 
        next nil unless v[:with_all]
        k 
      end.reject{|e| e.nil? || e == :beam}
      expect(hidden_elements :all, {except: [:beam]}).to eq(liste_cles)
    end
  end
  describe "#hide" do
    it 'produit une erreur sans argument' do
      expect{hide}.to raise_error ArgumentError
    end
    it 'retourne le bon code avec un unique argument' do
      expect(hide :bar).to eq(' \hide Staff.BarLine ')
      expect(hide :barre).to eq(' \hide Staff.BarLine ')
      expect(hide :stem).to eq(' \hide Stem ')
      expect(hide :hampe).to eq(' \hide Stem ')
      expect(hide :rest).to eq(' \hide Rest ')
      expect(hide :silence).to eq(' \hide Rest ')
    end
    
    it 'retourne le bon code avec un argument liste' do
      expect(hide [:bar, :stem]).to eq(' \hide Staff.BarLine \hide Stem ')
    end
  end
  
  describe "#show" do
    it 'ne produit pas une erreur sans argument' do
      hide(:beam)
      expect{show}.to_not raise_error
    end
    it 'retourne le bon code avec un seul argument' do
      expect(show :bar).to eq(' \undo \hide Staff.BarLine ')
      expect(show :barre).to eq(' \undo \hide Staff.BarLine ')
      expect(show :stem).to eq(' \undo \hide Stem ')
      expect(show :hampe).to eq(' \undo \hide Stem ')
      expect(show :rest).to eq(' \undo \hide Rest ')
      expect(show :silence).to eq(' \undo \hide Rest ')
    end
    it 'retourne le bon code avec une liste' do
      expect(show [:bar, :stem]).to eq(' \undo \hide Staff.BarLine \undo \hide Stem ')
    end
  end
  
end