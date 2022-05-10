

const initialState = {
    usersArr: [],
    loading: false,
    currentUser: null,
    taskArr: [],
    search:''
}
export const userReducers = (state = initialState, action) => {
    switch (action.type) {
        case "USER_ADDED": return {
            ...state,
            usersArr: [...state.usersArr, action.payload],
            currentUser: action.payload,
            taskArr: []
        }
        case "CURRENT_USER": return {
            ...state, currentUser: action.payload.user, taskArr: action.payload.task
        }
        case "TASK_COMPLATED":
            let arr = [...state.taskArr]
            arr.forEach(item => {
                if (item.id == action.payload.id)
                    item.completed = true
            })
            console.log("arr", arr,action.payload.id);
            return {
                ...state, taskArr: arr
            }
        case "SAVE_TASK": return {
            ...state, taskArr: [...state.taskArr, action.payload]
        }
        case "TASK_DELETED":
            let arr1 = [...state.taskArr]
            arr1=arr1.filter(task => task.id != action.payload.id)
            console.log(arr1);
            return {
                ...state, taskArr: [...arr1]
            }
        case "USER_LOGOUT":
            return {
                ...state, currentUser: null
            }
            case "SEARCH_ADDED":
                return {
                    ...state, search: action.payload
                }
        default: return state
    }
}