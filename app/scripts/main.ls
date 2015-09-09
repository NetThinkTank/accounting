words = []
noResultsYet = true
results = ($ '#results')

allKLength = (set, k) ->
    words := []

    n = set.length
    allKLengthRec(set, '', n, k)

allKLengthRec = (set, prefix, n, k) ->         
    if k == 0
        words.push prefix
        return

    for i from 0 to n - 1
        newPrefix = prefix + set[i]
        allKLengthRec(set, newPrefix, n, k - 1)

calculate = (word, values) ->
    sum = 0
    
    for i from 0 to (word.length - 1)
        if word[i] == '0'
            continue
        else if word[i] == '+'
            sum = sum + values[i]
        else if word[i] == '-'
            sum = sum - values[i]
            
    console.log 'WORD: ', word, ' SUM: ', sum
    return sum

display = (word, names, values, sum) ->
    output = ''
    
    for i from 0 to (word.length - 1)
        if word[i] == '0'
            continue
        else if word[i] == '+'
            output += ' ' + '+ ' + names[i]
        else if word[i] == '-'
            output += ' ' + '- ' + names[i]
        
    output += ' = ' + sum
    output = output.trim!

    if noResultsYet
        noResultsYet := false
        results.val output
    else
        results.val (results.val! + '\n' + output)

process = ->
    noResultsYet := true
    results.val 'No results found.'

    formValues = ($ '#values').val!
    
    delimiter = /[\s]?[,;\n\r]+[\s]?/
    formValues = formValues.replace delimiter, ','
    formValues = formValues.split ','

    console.log 'FORM VALUES: ', formValues

    names = []
    values = []
    
    for fv in formValues
        delimiter = /[\s]?[:=]+[\s]?/
        nameValue = fv.split(delimiter)
        
        if nameValue.length != 2
            continue
        
        nameValue[1] = parseInt nameValue[1]
        
        if isNaN(nameValue[1])
            continue
        
        # console.log 'NAME VALUE 0: ', nameValue[0]
        # console.log 'NAME VALUE 1: ', nameValue[1]
        
        names.push nameValue[0].trim!
        values.push nameValue[1]

    console.log 'NAMES: ', names
    console.log 'VALUES: ', values

    choices = ($ '#choices').val!
    
    delimiter = /[\s]?[,;\n\r]+[\s]?/
    choices = choices.replace delimiter, ','
    choices = choices.split ','

    choices = choices.map (x) -> return parseInt x, 10
    choices = choices.filter (x) -> return not isNaN x
    
    console.log 'CHOICES: ', choices
    
    allKLength ['-', '0', '+'], values.length

    for word in words
        console.log 'WORD: ', word
        
        sum = calculate word, values
        
        if (choices.indexOf sum) >= 0
            console.log 'FOUND: ', sum
            display word, names, values, sum
