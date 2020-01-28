#!/bin/bash

echo "Pick a dinosaur."
read -p "Press [Enter] when you have a dinosaur for me to guess."
win="no"

ankylosaurus() {
  echo "                            /~~~~~~~~~~~~\_ "
  echo "        _+=+_             _[~  /~~~~~~~~~~~~\_ "
  echo "       {''|''}         [~~~    [~   /~~~~~~~~~\_ "
  echo "        ''':-'~[~[~'~[~  ((++     [~  _/~~~~~~~~\_ "
  echo "             '=_   [    ,==, ((++    [    /~~~~~~~\-~~~-. "
  echo "                ~-_ _=+-(   )/   ((++  .~~~.[~~~~(  {@} \`. "
  echo "                        /   }\ /     (     }     (   .   ''} "
  echo "                       (  .+   \ /  //     )    / .,  ''''/ "
  echo "                       \\  \     \ (   .+~~\_  /.= /''''' "
  echo "                       <'_V_'>      \\  \    ~~~~~~\\  \ "
  echo "                                     \\  \          \\  \ "
  echo "                                     <'_V_'>        <'_V_'> "
}

spinosaurus() {
  echo "                        /|/|/|\\|\|                                       "
  echo "                      |  | | | | | |\                                   "
  echo "                    | | |  | || || | |\                                  "
  echo "                   /  | | |  || || ||||                                "
  echo "                   || | | |  | | |  | |\                                "
  echo "                 |  | | |  || ||  | | | \                                "
  echo "                /  |  | |  ||  | || | ||\                               "
  echo "                | | | | | || |  ||   | | |                              "
  echo "                | | |    | | || |  | | |||\                             "
  echo "               || |  | | | |  | || | | ||| \                           "
  echo "              ||  |    |   | | ||| |     | |                            "
  echo "              ||| | | |  | | |  || | | ||  |\                           "
  echo "              | | | | |  |   | || |||| ||| |\                           "
  echo "             /|  |  | | |  |  | | | || | ||  |                           " 
  echo "             |||| | |__ |__| |__|   || | || ||\                         "
  echo "            |_| _ --,   ,.. ,   ,.... _|_|_ || |\                       "
  echo "            /,   ,..,    ,.,    ,.. ,   ,..-|_\| |                       "
  echo "         _ /.,    ,.,    ,,     ,...   ,...,   .\\                        "
  echo "      _ /  ,..,    ,     ,      ,.,    ,.,    _ ...\\\\                 "
  echo "    _/       ',,   ,     ,       ,     .       \  .   .\\\\             "
  echo "  /     .       _--                       -\    \  .   ..  \\\\\         "  
  echo " /    O .   __ /    _/                 ____|    \       .       \\\\\\\  "
  echo " /      |---  /    /---__________------    |    |---____            |  \  "
  echo "/    ,; /     |    |                       |nn  |       ---____     |  |  "
  echo "|,,,','/      /nn  |                                            ---|   |   "
  echo " ;,,;/                                                     _______/   /   "
  echo "                                                   --------_________/  "
}

parasaurolophus() {
echo '                      _                                     '
echo '                     / \                                    '
echo '                    /  /                                    '
echo '                  //  /                                     '
echo '                 /  //                                       '  
echo '               //  /                                          '
echo '              /   /                                          '
echo '             /  //                                           '
echo '            /  /  \                                          '
echo '            / /    \\                                        '
echo '           /  |O \   \\\                                     '
echo '           /     /      \\\                                  '
echo '           /    /\         \\\\                              '
echo '           /  //  \\           \\\\\\\\\\\\\\      '
echo '           OO//     \\                       \\\\\\\\\\\\\        '
echo '                      \\\ _                               \\\\\\\\ '
echo '                        \/                                        \\\\\\\     ' 
echo '                        /     /                                           \\\ '
echo '                      ///    /              //                              \\ '
echo '                     / /    /              /      \                           \ '
echo '           -\       / /   //\\            /       /                         /  \ '
echo '            |\___--- |   /    \\\        /        /           /////////////_/  / '
echo '            \        |  |        \\\\    /        /   //////////     ___---    / '
echo '             -------/|  |            \\\/        //////         ___--          / '
echo '                     |  \              /       //   _______-----         _____/ '
echo '                     |  |              /      /      ----____   ____----- '
echo '                      \ \             /     // \     /       --- '
echo '                       \ \            /    /    \    \      '
echo '                        |/            \    \     \   \      '
echo '                        |              \    \    \    \     '
echo '                                        \   \     \   /     '
echo '                                        \   \     \   /     '
echo '                                         \  /     /  /      '
echo '                                         \  /     /  /      '
echo '                                         /  /     /  /     ' 
echo '                                      __/   \  __/   \    '    
echo '                                     /-____-\ / /=__-\   '
}

dinoclass() {
  #class = $1
  #species = $2
  class=$1
  species=$2
  echo "Is your dinosaur a/an $class?"
  read answer
  case $answer in
    "y"|"Y"|"yes"|"YES")
      echo "So, your dinosaur is a/an $class."
      guess=$class
      if [[ "$species" == "yes" ]]; then
        echo "I win, you lose."
        exit
      fi
      break
      ;;
    *)
      echo "Your dinosaur is NOT a $class...Hmmm..."
      ;;
  esac
}

for class in "raptor" "theropod" "stegosaur" "ceratopsian" "sauropod" "ankylosaur" "pachycephalosaur" "hadrosaur"; do
  dinoclass $class
done

case $guess in
  "raptor")
    for guess2 in "Velociraptor" "Oviraptor" "Utahraptor" "Dakotaraptor" "Dromaeosaurus" "Deinonychyus"; do
      dinoclass $guess2 "yes"
    done
    ;;
  "theropod")
    for guess2 in "T-Rex" "Allosaurus" "Gorgosaurus" "Indominus_Rex" "Yangchuanosaurus" "Spinosaurus" "Giganotosaurus" "Carcharodontoisaurus" "Acrocanthosaurus" "Mapusaurus"; do
      if [[ $guess2 == "Spinosaurus" ]]; then
        spinosaurus
      fi
      dinoclass $guess2 "yes"
    done
    ;;
  "stegosaur")
    for guess2 in "Huayangosaurus" "Gigantspinosaurus" "Stegosaurus" "Kentrosaurus"; do
      dinoclass $guess2 "yes"
    done
    ;;
  "ceratopsian")
    for guess2 in "Nedoceratops" "Triceratops" "Protoceratops" "Styracosaurus" "Kosmoceratops"; do
      dinoclass $guess2 "yes"
    done
    ;;
  "sauropod")
    for guess2 in "Brachiosaurus" "Supersaurus" "Argentinosaurus" "Sauroposeidon" "Xinjiangtitan" "Astrodon_Johnstoni" "Diplodocus" "Apatosaurus" "Alamosaurus"; do
      dinoclass $guess2 "yes"
    done
    ;;
  "ankylosaur")
    for guess2 in "Ankylosaurus" "Euoplocephalus" "Anodontosaurus"; do
      if [[ $guess2 == "Ankylosaurus" ]]; then
        ankylosaurus
      fi
      dinoclass $guess2 "yes"
    done
    ;;
  "pachycephalosaur")
    for guess2 in "Pachycephalosaurus" "Stygimoloch" "Dracorex" "Stegoceras"; do
      dinoclass $guess2 "yes"
    done
    ;;
  "hadrosaur")
    for guess2 in "Maiasaura" "Edmontosaurus" "Parasaurolophus" "Corythosaurus"; do
      if [[ $guess2 == "Parasaurolophus" ]]; then
        parasaurolophus
      fi
      dinoclass $guess2 "yes"
    done
    ;;
esac
echo "I lose, you win."
