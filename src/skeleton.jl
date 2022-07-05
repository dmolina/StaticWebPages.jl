"""
    head(info::Dict{String,String}, page::String)

Generate the head section for a `page` given the global `info`.
"""
function head(info::Dict{String,String}, page::String)
    subtitle = page == "index" ? "homepage" : page

    return str = """
                 <head>
                   <meta charset="utf-8">
                   <meta http-equiv="x-ua-compatible" content="ie=edge">
                   <meta name="viewport" content="width=device-width, initial-scale=1.0">
                   <title>$(info["title"]): $(subtitle)</title>
                   <link rel="stylesheet" href="css/foundation.min.css">
                   <link rel="stylesheet" href="https://cdn.rawgit.com/jpswalsh/academicons/master/css/academicons.min.css">
                   <script src="https://kit.fontawesome.com/06a987762e.js" crossorigin="anonymous"></script>
                   <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
                    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
                   <link rel="stylesheet" href="css/app.css">
                 </head>
                 """
end

"""
    nav(info::Dict{String,String}, content::OrderedDict{String,Any}, page::String, opt_in::Bool)

Generate the navigation menu for a `page` given its `content`, and the global `info`. Please set `opt_in` to `true` to promote `StaticWebPages`.
"""
function nav(
    info::Dict{String,String}, content::OrderedDict{String,Any}, page::String, opt_in::Bool
)
    avatar = get(info, "avatar_shape", "round") == "raw" ? "avatar_raw" : "avatar_round"
    str = """
          <div class="top-bar">
            <button class="close-button" aria-label="Close menu" type="button" data-close>
              <span aria-hidden="true">&times;</span>
            </button>
            <ul class="vertical dropdown menu" id="menu" data-dropdown-menu>
              <img src="img/$(info["avatar"])" alt="$(info["title"])" class="$avatar">
              <li class="menu-text">$(info["name"])</li>
          """

    for (p, c) in content
        item = p == "index" ? "Home" : uppercasefirst(p)
        if page == p
            str *= """
                   <li class="is-active"><a href="$p.html">$item</a></li>
                   """
        else
            str *= """
                   <li><a href="$p.html">$item</a></li>
                   """
        end
    end

    str *=
        "cv" ∈ keys(info) ? """\n<li><a href="files/$(info["cv"])">C.V.</a></li>\n""" : ""

    if "email" ∈ keys(info)
        if length(info["email"]) > 20
            aux = split(info["email"], "@")
            str *= """\n<li><span class="obfuscate unselectable nota">$(reverse(aux[1]))</span></li>\n"""
            str *= """\n<li><span class="obfuscate unselectable nota">$(reverse(aux[2]))@</span></li>\n"""
        else
            str *= """\n<li><span class="obfuscate unselectable nota">$(reverse(info["email"]))</span></li>\n"""
        end
    end

    acc = 1
    for i in keys(academicons)
        if i ∈ keys(info)
            if mod(acc, 4) == 1
                if acc > 1
                    str *= """
                               </li>
                           """
                end
                str *= """
                           <li>
                       """
            end
            str *= """
                         <a href="$(info[i])" class="icon-menu" title="" target="_blank" data-original-title="Cite">
                           <i class="$(academicons[i])"></i>
                         </a>
                   """
            acc += 1
        end
    end
    if "discord" ∈ keys(info)
        if mod(acc, 4) == 1
            if acc > 1
                str *= """
                           </li>
                       """
            end
            str *= """
                     <li>
                   """
        end
        str *= """
                         <a href="$(info["discord"])" class="icon-menu" title="" target="_blank" data-original-title="Cite">
                           <svg
                               width="26.25"
                               height="26.4"
                               viewBox="0 0 71 65"
                               fill="none"
                               xmlns="http://www.w3.org/2000/svg">
                               <path d="M60.1045 13.8978C55.5792 11.8214 50.7265 10.2916 45.6527 9.41542C45.5603 9.39851 45.468 9.44077 45.4204 9.52529C44.7963 10.6353 44.105 12.0834 43.6209 13.2216C38.1637 12.4046 32.7345 12.4046 27.3892 13.2216C26.905 12.0581 26.1886 10.6353 25.5617 9.52529C25.5141 9.44359 25.4218 9.40133 25.3294 9.41542C20.2584 10.2888 15.4057 11.8186 10.8776 13.8978C10.8384 13.9147 10.8048 13.9429 10.7825 13.9795C1.57795 27.7309 -0.943561 41.1443 0.293408 54.3914C0.299005 54.4562 0.335386 54.5182 0.385761 54.5576C6.45866 59.0174 12.3413 61.7249 18.1147 63.5195C18.2071 63.5477 18.305 63.5139 18.3638 63.4378C19.7295 61.5728 20.9469 59.6063 21.9907 57.5383C22.0523 57.4172 21.9935 57.2735 21.8676 57.2256C19.9366 56.4931 18.0979 55.6 16.3292 54.5858C16.1893 54.5041 16.1781 54.304 16.3068 54.2082C16.679 53.9293 17.0513 53.6391 17.4067 53.3461C17.471 53.2926 17.5606 53.2813 17.6362 53.3151C29.2558 58.6202 41.8354 58.6202 53.3179 53.3151C53.3935 53.2785 53.4831 53.2898 53.5502 53.3433C53.9057 53.6363 54.2779 53.9293 54.6529 54.2082C54.7816 54.304 54.7732 54.5041 54.6333 54.5858C52.8646 55.6197 51.0259 56.4931 49.0921 57.2228C48.9662 57.2707 48.9102 57.4172 48.9718 57.5383C50.038 59.6034 51.2554 61.5699 52.5959 63.435C52.6519 63.5139 52.7526 63.5477 52.845 63.5195C58.6464 61.7249 64.529 59.0174 70.6019 54.5576C70.6551 54.5182 70.6887 54.459 70.6943 54.3942C72.1747 39.0791 68.2147 25.7757 60.1968 13.9823C60.1772 13.9429 60.1437 13.9147 60.1045 13.8978ZM23.7259 46.3253C20.2276 46.3253 17.3451 43.1136 17.3451 39.1693C17.3451 35.225 20.1717 32.0133 23.7259 32.0133C27.308 32.0133 30.1626 35.2532 30.1066 39.1693C30.1066 43.1136 27.28 46.3253 23.7259 46.3253ZM47.3178 46.3253C43.8196 46.3253 40.9371 43.1136 40.9371 39.1693C40.9371 35.225 43.7636 32.0133 47.3178 32.0133C50.9 32.0133 53.7545 35.2532 53.6986 39.1693C53.6986 43.1136 50.9 46.3253 47.3178 46.3253Z" fill="#FFFFFF"></path>
                           </svg>
                         </a>
               """
        acc += 1
    end
    str *= acc > 1 ? "\n<li>\n" : ""

    aux = """\n<div class="opt-in">This site was generated using <a href="https://github.com/Humans-of-Julia/StaticWebPages.jl">StaticWebPages.jl</a></div></li>\n"""
    str *= """
                 $(opt_in ? aux : "")
               </ul>
             </div>
           """
    return str
end

function js()
    str = """
    <script src="js/vendor/jquery.js"></script>
    <script src="js/vendor/what-input.js"></script>
    <script src="js/vendor/foundation.min.js"></script>
    <script src="js/app.js"></script>

    <script>
         \$(document).ready(function() {
            \$(document).foundation();
         })
     </script>
    """
    return str
end
