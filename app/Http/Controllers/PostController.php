<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $posts = Post::all();
        return response()->json($posts);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'content' => 'required',
            'description' => 'required',
            'category' => 'required',
        ]);

        $post = Post::create([
            'title' => $request->title,
            'content' => $request->content,
            'description' => $request->description,
            'category' => $request->category,
        ]);

        return response()->json($post);
    }

    /**
     * Display the specified resource.
     */
    public function show($postId)
    {
        $post = Post::findOrFail($postId);
        return response()->json($post);
    }
    

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
    {
       //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);

        // Validate the request data
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'required|in:PHP,HTML,CSS',
        ]);

        // Update the post
        $post->update($request->all());
        return response()->json($post);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $post = Post::findOrFail($id);
        $post->delete();

        return response()->json(['message' => 'Post deleted successfully']);
    }

    public function getAll(){

        $allCategory = Post::count();
        $totPhp = Post::where('category', 'PHP')->count();
        $totHtml = Post::where('category', 'HTML')->count();
        $toCss = Post::where('category', 'CSS')->count();

        return response()->json([
            'total' => $allCategory,
            'totPhp' => $totPhp,
            'totHtml' => $totHtml,
            'totCss' => $toCss,
        ]);
    }
}
