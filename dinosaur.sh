#!/bin/bash

main() {
  echo "Pick a dinosaur."
  read -p "Press [Enter] when you have a dinosaur for me to guess."
  guessmethod
  read -p "I give up, what is it?" dinostoadd
  echo $dinostoadd >> dinostoadd.txt
}

triassicdinos="$(shuf -e Eoraptor Herrerasaurus Marasuchus Ichthyosaurus Nothosaurus Camposaurus Caseosaurus Chindesaurus Coelophysis Daemonosaurus Gojirasaurus Lepidus_praecisio Tawa_hallae)"
jurassicdinos="$(shuf -e Stegosaurus Allosaurus Brachiosaurus Kentrosaurus Yangchuanosaurus Huayangosaurus Gigantspinosaurus Kentrosaurus Brachiosaurus Supersaurus Xinjiangtitan Diplodocus Apatosaurus Plesiosaurus Ichthyosaurus Pterodactylus Dimorphodon Dilophosaurus Sarahsaurus)"
cretaceousdinos="$(shuf -e Velociraptor Oviraptor Utahraptor Dakotaraptor Dromaeosaurus Deinonychus Giganotasaurus T-Rex Gorgosaurus Spinosaurus Carcharodontosaurus Acrocanthosaurus Mapusaurus Troodon Nedoceratops Triceratops Protoceratops Styracosaurus Kosmoceratops Torosaurus Argentinosaurus Sauroposeidon Astrodon_Johnstoni Alamosaurus Ankylosaurus Euoplocephalus Anodontosaurus Nodosaurus Aletopelta Pachycephalosaurus Stygimoloch Dracorex Stegoceras Maiasaura Edmontosaurus Parasaurolophus Corythosaurus Iguanodon Gryposaurus Mosasaurus Cretoxyrhina Megalodon Kronosaurus Archelon Pteranodon Hatzegopteryx Quetzalcoatlus Pterodaustro)"
fictionaldinos="$(shuf -e Indominus_Rex)"
dinofamilies="$(shuf -e raptor theropod stegosaur ceratopsian sauropod ankylosaur pachycephalosaur hadrosaur marine_reptile pterosaur)"
raptors="$(shuf -e Velociraptor Oviraptor Utahraptor Dakotaraptor Dromaeosaurus Deinonychyus)"
theropods="$(shuf -e T-Rex Allosaurus Gorgosaurus Indominus_Rex Yangchuanosaurus Spinosaurus Giganotosaurus Carcharodontosaurus Acrocanthosaurus Mapusaurus Troodon Camposaurus Caseosaurus Chindesaurus Coelophysis Daemonosaurus Gojirasaurus Lepidus_praecisio Tawa_hallae Dilophosaurus)"
stegosaurs="$(shuf -e Huayangosaurus Gigantspinosaurus Stegosaurus Kentrosaurus)"
ceratopsians="$(shuf -e Nedoceratops Triceratops Protoceratops Styracosaurus Kosmoceratops Torosaurus)"
sauropods="$(shuf -e Brachiosaurus Supersaurus Argentinosaurus Sauroposeidon Xinjiangtitan Astrodon_Johnstoni Diplodocus Apatosaurus Alamosaurus Plateosaurus Sarahsaurus)"
ankylosaurs="$(shuf -e Ankylosaurus Euoplocephalus Anodontosaurus Nodosaurus Aletopelta)"
pachycephalosaurs="$(shuf -e Pachycephalosaurus Stygimoloch Dracorex Stegoceras)"
hadrosaurs="$(shuf -e Maiasaura Edmontosaurus Parasaurolophus Corythosaurus Iguanodon Gryposaurus)"
marine_reptiles="$(shuf -e Mosasaurus Cretoxyrhina Megalodon Plesiosaurus Ichthyosaurus Nothosaurus Kronosaurus Archelon)"
pterosaurs="$(shuf -e Pteranodon Hatzegopteryx Pterodactylus Quetzalcoatlus Pterodaustro Dimorphodon)"

guessmethod() {
  echo "How would you like to play?"
  echo "1. By dinosaur family."
  echo "2. By time period."
  echo "3. Randomly."
  echo ""
  read method
  case $method in
    "1")
      family
      ;;
    "2")
      period
      ;;
    "3")
      random
      ;;
    *)
      echo "Please try again."
      exit 1
      ;;
  esac
} #guessmethod

period() {
  echo "Which period did your dinosaur live in?"
  echo "1. Triassic"
  echo "2. Jurassic"
  echo "3. Cretaceous"
  echo "4. Fictional"
  echo ""
  read choice
  while true; do
    case $choice in
      "1")
        triassic
        break
      ;;
      "2")
        jurassic
        break
      ;;
      "3")
        cretaceous
        break
      ;;
      "4")
        fictional
        break
      ;;
      *)
        echo "Invalid choice. Please try again."
        echo ""
        read choice
      ;;
    esac
  done
}

triassic() {
  for dino in $triassicdinos; do
    dinoclass $dino "yes"
  done
}

jurassic() {
  for dino in $jurassicdinos; do
    dinoclass $dino "yes"
  done
}

cretaceous() {
  for dino in $cretaceousdinos; do
    dinoclass $dino "yes"
  done
}

fictional() {
  for dino in $fictionaldinos; do
    dinoclass $dino "yes"
  done
}

random() {
  dinos=$(shuf -e $triassicdinos $jurassicdinos $cretaceousdinos $fictionaldinos)
  for dino in $dinos; do
    dinoclass $dino "yes"
  done 
}

family() {
for class in $dinofamilies; do
  dinoclass $class
done

case $guess in
  "raptor")
    for guess2 in $raptors; do
      dinoclass $guess2 "yes"
    done
    ;;
  "theropod")
    for guess2 in $theropods; do
#      if [[ $guess2 == "Spinosaurus" ]]; then
#        spinosaurus
#      fi
      dinoclass $guess2 "yes"
    done
    ;;
  "stegosaur")
    for guess2 in $stegosaurs; do
      dinoclass $guess2 "yes"
    done
    ;;
  "ceratopsian")
    for guess2 in $ceratopsians; do
      dinoclass $guess2 "yes"
    done
    ;;
  "sauropod")
    for guess2 in $sauropods; do
      dinoclass $guess2 "yes"
    done
    ;;
  "ankylosaur")
    for guess2 in $ankylosaurs; do
#      if [[ $guess2 == "Ankylosaurus" ]]; then
#        ankylosaurus
#      fi
      dinoclass $guess2 "yes"
    done
    ;;
  "pachycephalosaur")
    for guess2 in $pachycephalosaurs; do
      dinoclass $guess2 "yes"
    done
    ;;
  "hadrosaur")
    for guess2 in $hadrosaurs; do
#      if [[ $guess2 == "Parasaurolophus" ]]; then
#        parasaurolophus
#      fi
      dinoclass $guess2 "yes"
    done
    ;;
  "marine_reptile")
    for guess2 in $marine_reptiles; do
      dinoclass $guess2 "yes"
    done
    ;;
  "pterosaur")
    for guess2 in $pterosaurs; do
      dinoclass $guess2 "yes"
    done
    ;;
esac
} #family

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
  case $1 in
    "Parasaurolophus")
      parasaurolophus
    ;;
    "Spinosaurus")
      spinosaurus
    ;;
    "Ankylosaurus")
      ankylosaurus
    ;;
  esac
  echo "Is your dinosaur a/an $class?"
  read answer
  case $answer in
    "y"|"Y"|"yes"|"YES")
      echo "So, your dinosaur is a/an $class."
      guess=$class
      if [[ "$species" == "yes" ]]; then
        echo "Yay, I figured out your dinosaur."
        exit
      fi
      break
      ;;
    *)
      echo "Your dinosaur is NOT a $class...Hmmm..."
      ;;
  esac
}

main
