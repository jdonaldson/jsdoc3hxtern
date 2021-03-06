/**
  Typedefs and helpers for jsdoc3 doclets
 **/

/**
  The base doclet type.  Most doclets should have this info.
 **/
typedef Doclet = {
    name         : Dynamic,
    comment      : String,
    ?meta        : Dynamic,
    kind         : String,
    longname     : String,
    ?see         : Array<String>,
    ?description : String,
    ?memberof : String
}

/**
  A file doclet
 **/
typedef DocletFile = {
    > Doclet,
    preserveName : String
}

/**
  Member base.  Simple fields have a type, member functions have this info
  in their params
 **/
typedef DocletMemberBase = {
    > Doclet,
    // memberof   : String,
    scope      : String, // static, instance, global
    ?access    : String, // private
}

typedef DocletMember = {
    > DocletMemberBase,
    type : { names : Array<String>},
}

typedef DocletFunction = {
    > DocletMemberBase,
    params : Array<FunctionParam>,
}

/**
  These can be simple aliases, no additional specific info.
 **/
typedef DocletClass    = DocletMember;
typedef DocletConstant = DocletMemberBase;
typedef DocletTypedef  = DocletMember;

/**
  packages sometimes have version, license, etc. info
 **/
typedef DocletPackage = {
    >Doclet,
    version  : String,
    licenses : String,
    files    : Array<String>
}


/**
  Wrap all expected types
 **/
enum DocletType {
    DocletFile     (doc: DocletFile);
    DocletMember   (doc: DocletMember);
    DocletFunction (doc: DocletFunction);
    DocletClass    (doc: DocletClass);
    DocletConstant (doc: DocletConstant);
    DocletTypedef  (doc: DocletTypedef);
    DocletPackage  (doc: DocletPackage);
    DocletUnknown  (doc: Doclet);
}


typedef Pack = {
    name : String,
    packs : Map<String,Pack>,
    classes : Map<String, Clazz>, 
}

typedef Clazz = {
    type       : String,
    pack       : Pack,
    ?extend    : String,
    ?implement : String,
    pname      : String,
    name       : String,
    signature  : String,
    is_private : Bool,
    ?native    : String,
    ?fields    : Array<String>,
    ?comment   : String,
}




/**
  The metadata that most doclets posess.  TODO: figure out which ones have
  this *for sure*
 **/
typedef Meta = {
    filename : String,
    range    : Array<Int>,
    lineno   : Int,
    path     : String,
    code     : Dynamic // TODO
}

/**
  Simple helper class to disambiguate the dynamic anonymous object information
  in extracted doclets
 **/
class DocletHelper {
    /**
      Looks at the the doclet kind and return the enum for the
      proper type.
     **/
    public static function docletType(doc:Doclet) : DocletType{
        return switch(doc.kind){
            case 'file'     : DocletFile     (cast doc);
            case 'function' : DocletFunction (cast doc);
            case 'member'   : DocletMember   (cast doc);
            case 'class'    : DocletClass    (cast doc);
            case 'constant' : DocletConstant (cast doc);
            case 'typedef'  : DocletTypedef  (cast doc);
            case 'package'  : DocletPackage  (cast doc);
            default         : DocletUnknown  (doc);
        }
    }
}

/**
  Function params
 **/
typedef FunctionParam = {
    type          : { names : Array<String> },
    ?optional     : Bool,
    ?nullable     : Bool,
    ?variable     : Bool,
    ?defaultvalue : Bool,
    description   : String,
    name          : String
}

