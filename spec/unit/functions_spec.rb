require "spec_helper"


describe "Fonctions" do
  
  
  describe "#hide" do
    it 'produit une erreur sans argument' do
      expect{hide}.to raise_error ArgumentError
    end
    it 'retourne le bon code' do
      expect(hide :bar).to eq(' \hide Staff.BarLine ')
      expect(hide :barre).to eq(' \hide Staff.BarLine ')
      expect(hide :stem).to eq(' \hide Stem ')
      expect(hide :hampe).to eq(' \hide Stem ')
      expect(hide :rest).to eq(' \hide Rest ')
      expect(hide :silence).to eq(' \hide Rest ')
    end
  end
  
  describe "#show" do
    it 'produit une erreur sans argument' do
      expect{show}.to raise_error ArgumentError
    end
    it 'retourne le bon code' do
      expect(show :bar).to eq(' \undo \hide Staff.BarLine ')
      expect(show :barre).to eq(' \undo \hide Staff.BarLine ')
      expect(show :stem).to eq(' \undo \hide Stem ')
      expect(show :hampe).to eq(' \undo \hide Stem ')
      expect(show :rest).to eq(' \undo \hide Rest ')
      expect(show :silence).to eq(' \undo \hide Rest ')
    end
  end
  
end