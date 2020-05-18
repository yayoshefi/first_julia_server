module yair_devController
  # Build something great
using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests


function in_form()
  state=Dict("samp_str" => "hello", "samp_arr" => ["a", "b"] );

  form = """
  <form action="/dev1" method="POST" enctype="multipart/form-data">
    <input type="text" name="name" value="" placeholder="What's your name?" />
    <input type="hidden" name="state" value=$(HttpCommon.escapeHTML(string(state))) />
    <br>
    <p> choose interval</p>
    <input type="radio" name="week" />
    <label for="week">week interval</label>
    <input type="radio" name="day"  checked/>
    <label for="daty">day interval</label>
    <input type="submit" value="Welcomeing" />
  </form>
  """
  @info "servnig NO specifing version"
  html(form)
end

function out_form()
  @info "servnig POST version" #, payload=postpayload()
  state_str = postpayload(:state, "Dict()")
  println("got this state str $state_str")
  try
    exp_state = Meta.parse(state_str)
    d_state=eval(exp_state)
    println("input state: $(state_str);   after eval $(d_state)")
  catch
    println("didnt work")
  end
  #return this array
  [
  Html.h3("form recieved! Hello  $(postpayload(:name, "Anon")) "),
  Html.hr(),
  Html.div(
    Html.h3("post data dictionary:<br>  $(string(postpayload())) "),
    [Html.h4("$(k):  $(v)<br>") for (k,v) in postpayload()]
    ),

  Html.hr(),
  Html.h3("all @paramas keys values :"),
  Html.div(
    [Html.h5("$(k):  $(v)<br>") for (k,v) in @params]
    ),
  ]

end


end # module yair_devController
