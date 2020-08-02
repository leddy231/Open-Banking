
function dig(obj, string) {
    let levels = string.split(".");
    if (levels.length == 0) {
        return null 
    }
    var result = obj;

    levels.forEach((level) => {
        result = result[level]
        if(result == null) {
            return null;
        }
    })
    return result;
}

export function wrangle(input, filter) {
    if(typeof filter === 'string') {
        return dig(input, filter);
    }
    if(Array.isArray(filter)) {
        return filter.map((item) => wrangle(input, item));
    }
    if(typeof filter === 'function') {
        return filter(input);
    }
    if(typeof filter === 'object') {
        let result = {}
        for (const [key, item] of Object.entries(filter)) {
            result[key] = wrangle(input, item);
        }
        return result
    }
}

export function firstOf(list) {
    return (input) => {
        list.forEach(item => {
            let result = wrangle(input, item);
            if(result) {
                return result;
            }
        });
    }
}

export function concat(list) {
    return (input) => {
        let out = list.map((item) => wrangle(input, item));
        return out.reduce((accumulator, currentValue) => accumulator + currentValue);
    }
}

export function join(list) {
    return (input) => {
        let out = list.map((item) => wrangle(input, item));
        let res = []
        out.forEach(l => {
            res = res.concat(l)
        })
        return res
    }
}

export function map(name, filter) {
    return (input) => {
        let list = wrangle(input, name);
        return list.map((item) => wrangle(item, filter));
    }
}

export function cnst(value) {
    return (input) => value
}

export function filter(value, fun) {
    return (input) => fun(wrangle(input, value));
}
