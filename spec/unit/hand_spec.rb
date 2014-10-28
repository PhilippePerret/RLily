require "spec_helper"

describe "Class Hand #{relative_path __FILE__}" do
  def hand
    @hand ||= LeftHand::new
  end
  # Définit les notes de la main, en initialisant "@notes"
  def set_notes notes
    hand.instance_variable_set('@notes', [notes])
  end
  it 'existe' do
    expect(Hand).to be_instance_of Class
  end
  
  describe "Méthode" do
    
    describe "#correct_notes" do
      it 'répond' do
        expect(hand).to respond_to :correct_notes
      end
      it 'retourne les notes corrigées' do
        expect(hand.correct_notes "a#").to eq('ais')
      end
      describe "corrige" do
        
        # Dièses
        it 'les # en is' do
          expect(hand.correct_notes 'a#').to eq('ais')
        end
        # Bémols
        it 'les “b” en “es” sauf si c’est la note SI' do
          expect(hand.correct_notes 'bb').to eq('bes')
          expect(hand.correct_notes 'cb b bb a# r').to eq('ces b bes ais r')
        end
        it 'les doubles bémol en "es"' do
          expect(hand.correct_notes 'bbb').to eq('beses')
          expect(hand.correct_notes 'b bb bbb cb b bb').to eq('b bes beses ces b bes')
        end
        
        # Barres
        it 'les barres de fin (||.)' do
          expect(hand.correct_notes 'c d e ||.').to eq('c d e \bar "|."')
        end
      end
    end
    
    describe "#correct_final_notes" do
      it 'répond' do
        expect(hand).to respond_to :correct_final_notes
      end
      describe "corrige…" do
        # Barres
        it 'les “||” en “ \bar "||" ”' do
          set_notes  'c || a'
          expect(hand.correct_final_notes ).to eq('c \bar "||" a')
        end
        it 'les barres de reprises' do
          set_notes '|: c a g :|'
          expect(hand.correct_final_notes).to eq('\bar ".|:" c a g \bar ":|."')
        end
        it 'des barres de reprise avec alternative' do
          set_notes "|: c1 |1 d :|2 e || f"
          str_final = '\repeat volta 2 { c1 } \alternative { { d }{ e } } f'
          expect(hand.correct_final_notes).to eq(str_final)
        end
        it 'des barres de reprise avec alternative se terminant par une double barre' do
          set_notes "|: c1 |1 d :|2 e || || f"
          str_final = '\repeat volta 2 { c1 } \alternative { { d }{ e } } \bar "||" f'
          expect(hand.correct_final_notes).to eq(str_final)
        end
      end
    end
    
  end

end