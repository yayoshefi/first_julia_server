module yair_devController
  # Build something great
using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests

macro log_fmt(msg)
  return "Module $(@__MODULE__): in $(@__FILE__)+$(@__LINE__):: $msg"
end



function in_form()
  form = """
  <form action="/dev1" method="POST" enctype="multipart/form-data">
    <input type="text" name="name" value="" placeholder="What's your name?" />
    <input type="submit" value="Welcomeing" />
  </form>
  """
  @info "servnig NO specifing version"
  html(form)
end

function out_form()
  @info "servnig POST version" #, payload=postpayload()
  Html.h3("form recieved! Hello  $(postpayload(:name, "Anon")) ")
end


end # module yair_devController
