---@class Array : OxClass
lib.array = lib.class('Array')

---@alias ArrayLike<T> Array | { [number]: T }

---@private
function lib.array:constructor(...)
    local arr = { ... }

    for i = 1, #arr do
        self[i] = arr[i]
    end
end

---@private
function lib.array:__newindex(index, value)
    if type(index) ~= 'number' then error(("Cannot insert non-number index '%s' into an array."):format(index)) end

    rawset(self, index, value)
end

---Create a new array containing the elements of two or more arrays.
---@param ... ArrayLike
function lib.array:merge(...)
    local newArr = table.clone(self)
    local length = #self
    local arrays = { ... }

    for i = 1, #arrays do
        local arr = arrays[i]

        for j = 1, #arr do
            length += 1
            newArr[length] = arr[j]
        end
    end

    return lib.array:new(table.unpack(newArr))
end

---Tests if all elements in an array succeed in passing the provided test function.
---@param testFn fun(element: unknown): boolean
function lib.array:every(testFn)
    for i = 1, #self do
        if not testFn(self[i]) then
            return false
        end
    end

    return true
end

---Creates a new array containing the elements from an array thtat pass the test of the provided function.
---@param testFn fun(element: unknown): boolean
function lib.array:filter(testFn)
    local newArr = {}
    local length = 0

    for i = 1, #self do
        local element = self[i]

        if testFn(element) then
            length += 1
            newArr[length] = element
        end
    end

    return lib.array:new(table.unpack(newArr))
end

---Returns the first or last element of an array that passes the provided test function.
---@param testFn fun(element: unknown): boolean
---@param last? boolean
function lib.array:find(testFn, last)
    local a = last and #self or 1
    local b = last and 1 or #self
    local c = last and -1 or 1

    for i = a, b, c do
        local element = self[i]

        if testFn(element) then
            return element
        end
    end
end

---Returns the first or last index of the first element of an array that passes the provided test function.
---@param testFn fun(element: unknown): boolean
---@param last? boolean
function lib.array:findIndex(testFn, last)
    local a = last and #self or 1
    local b = last and 1 or #self
    local c = last and -1 or 1

    for i = a, b, c do
        local element = self[i]

        if testFn(element) then
            return i
        end
    end
end

---Returns the first or last index of the first element of an array that matches the provided value.
---@param value unknown
---@param last? boolean
function lib.array:indexOf(value, last)
    local a = last and #self or 1
    local b = last and 1 or #self
    local c = last and -1 or 1

    for i = a, b, c do
        local element = self[i]

        if element == value then
            return element
        end
    end
end

---Executes the provided function for each element in an array.
---@param cb fun(element: unknown)
function lib.array:forEach(cb)
    for i = 1, #self do
        cb(self[i])
    end
end

---Determines if a given element exists inside an array.
---@param element unknown The value to find in the array.
---@param fromIndex? number The position in the array to begin searching from.
function lib.array:includes(element, fromIndex)
    for i = (fromIndex or 1), #self do
        if self[i] == element then return true end
    end

    return false
end

---Concatenates all array elements into a string, seperated by commas or the specified seperator.
---@param seperator? string
function lib.array:join(seperator)
    return table.concat(self, seperator or ',')
end

---Create a new array containing the results from calling the provided function on every element in an array.
---@param cb fun(element: unknown, index: number, array: self): unknown
function lib.array:map(cb)
    local arr = {}

    for i = 1, #self do
        arr[i] = cb(self[i], i, self)
    end

    return lib.array:new(table.unpack(arr))
end

---Removes the last element from an array and returns the removed element.
function lib.array:pop()
    return table.remove(self)
end

---Adds the given elements to the end of an array and returns the new array length.
---@param ... any
function lib.array:push(...)
    local elements = { ... }
    local length = #self

    for i = 1, #elements do
        length += 1
        self[length] = elements[i]
    end

    return length
end

---The "reducer" function is applied to every element within an array, with the previous element's result serving as the accumulator.\
---If an initial value is provided, it's used as the accumulator for index 1; otherwise, index 1 itself serves as the initial value, and iteration begins from index 2.
---@generic T
---@param reducer fun(accumulator: T, currentValue: T, index?: number): T
---@param initialValue? T
---@return T
function lib.array:reduce(reducer, initialValue)
    local initialIndex = initialValue and 1 or 2
    local accumulator = initialValue or self[1]

    for i = initialIndex, #self do
        accumulator = reducer(accumulator, self[i], i)
    end

    return accumulator
end

---Reverses the elements inside an array.
function lib.array:reverse()
    local i, j = 1, #self

    while i < j do
        self[i], self[j] = self[j], self[i]
        i += 1
        j -= 1
    end

    return self
end

---Removes the first element from an array and returns the removed element.
function lib.array:shift()
    return table.remove(self, 1)
end

---Creates a new array with reversed elements from the given array.
function lib.array:toReversed()
    local reversed = lib.array:new()

    for i = #self, 1, -1 do
        reversed:push(self[i])
    end

    return reversed
end

---Returns true if the given table is an instance of array or an array-like table.
---@param tbl ArrayLike
---@return boolean
function lib.array.isArray(tbl)
    local tableType = table.type(tbl)

    if not tableType then return false end

    if tableType == 'array' or tableType == 'empty' or lib.array.instanceOf(tbl, lib.array) then
        return true
    end

    return false
end

return lib.array