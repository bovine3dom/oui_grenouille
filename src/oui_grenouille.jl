#!/bin/julia

using JSON3
using Base.Iterators: flatten

@enum GENDER MASCULINE FEMININE NEUTER

french = JSON3.read(read("$(@__DIR__)/../data/kaikki.org-dictionary-French.json"); jsonlines=true)

nouns =  filter(w -> w.pos == "noun" && !occursin(' ', w.word), french)

function sense2mf(tags)
    if "masculine" in tags
        MASCULINE
    elseif "feminine" in tags
        FEMININE
    else
        NEUTER
    end
end

sensegender = [[(word = n.word, gender = sense2mf(s.tags)) for s in n.senses if :tags in keys(s)] for n in nouns] |> flatten |> collect

# Last two characters of each word
Dict(s.word[prevind(s.word, ncodeunits(s.word), 1):end] => s.gender for s in sensegender if length(s.word) >= 3)

# Probably want to remove all the accents first:
# (In JS, do it this way)
#
#
# https://stackoverflow.com/questions/990904/remove-accents-diacritics-in-a-string-in-javascript#answers-header 
# const str = "Crème Brulée"
# str.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
# > "Creme Brulee"



# Fun things to do:
#
# Identify common endings, e.g. up to 5 characters long
#
# Plot gender versus ending - look for patterns
