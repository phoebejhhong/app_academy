require 'io/console'

chr = ''
whole = ''
while chr != "\r"
  chr = STDIN.getch
  whole += chr
end
p whole
