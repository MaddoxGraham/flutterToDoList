<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Task;

class TaskController extends Controller
{
    // get all data
   public function index(){
    return Task::all();
   }

   //add task
   public function store(Request $request){
   $task = new Task;
   $task->text=$request->text;
   $task->save();
   return $task;
   }

public function update(Request $request, $id) {
    $task = Task::find($id);
    $task->text = $request->text;
    $task->save();
    return $task;
}

   public function destroy($id) {
       Task::destroy($id);
       return response()->json(['message' => 'Task deleted']);
   }

}
