import { useRef } from "react";
import { Button, Card, Col } from "react-bootstrap"
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { addTask } from "../store/action/task";
const AddToDo = () => {
    let content=useRef()
    let navigate=useNavigate()
    let dispatch=useDispatch()
    let user=useSelector(state => state.currentUser)
     return (
          <Col>
        <Card style={{ width: '18rem' }} bg={'light'}>
            <Card.Header as="h5">Add Task:</Card.Header>
            <Card.Body>
                <Card.Title><label>content</label><input type={"text"} ref={content}/></Card.Title>
                {/* <Card.Text>
                With supporting text below as a natural lead-in to additional content.
            </Card.Text> */}
                <Button  onClick={() => {       
                        dispatch(addTask({"userId": user.id,"title": content.current.value,"completed": false},navigate))
                }}
                    variant="outline-secondary">{"add the task"}</Button>
                    <Button  onClick={() => {  navigate('/todo')      }}
                    variant="outline-secondary">{"cancel the task"}</Button>
            </Card.Body>
        </Card>
    </Col> 
    );
}
 
export default AddToDo;