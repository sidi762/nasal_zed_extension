;; Keywords
[
  "if"
  "else"
  "elsif"
  "while"
  "for"
  "foreach"
  "forindex"
  "break"
  "continue"
] @keyword

;; Operators
[
  "and" "or"
] @keyword.operator

[
  "!" "*" "-" "+" "~" "/" "==" "=" "!=" "<=" ">=" "<" ">" "?" ":" "*=" "/=" "+=" "-=" "~=" "..."
] @operator

;; Storage
[
  "func"
  "return"
  "var"
  "nil"
] @keyword.storage

;; Variables
[
  "me"
  "arg"
  "parents"
  "obj"
] @variable.special

;; Numbers
(number) @number
(hex_number) @number

;; Strings
(string) @string
(escaped_character) @string.escape

;; Comments
(comment) @comment

;; Core functions
[
  "append" "bind" "call" "caller" "chr" "closure" "cmp" "compile" "contains"
  "delete" "die" "find" "ghosttype" "id" "int" "keys" "left" "num" "pop"
  "right" "setsize" "size" "sort" "split" "sprintf" "streq" "substr" "subvec" "typeof"
] @function

;; FlightGear core extensions
[
  "abort" "abs" "aircraftToCart" "addcommand" "airportinfo" "airwaysRoute" "assert"
  "carttogeod" "cmdarg" "courseAndDistance" "createDiscontinuity" "createViaTo"
  "createWP" "createWPFrom" "defined" "directory" "fgcommand" "findAirportsByICAO"
  "findAirportsWithinRange" "findFixesByID" "findNavaidByFrequency" "findNavaidsByFrequency"
  "findNavaidsByID" "findNavaidsWithinRange" "finddata" "flightplan" "geodinfo"
  "geodtocart" "get_cart_ground_intersection" "getprop" "greatCircleMove" "interpolate"
  "isa" "logprint" "magvar" "maketimer" "start" "stop" "restart" "maketimestamp" "md5"
  "navinfo" "parse_markdown" "parsexml" "print" "printf" "printlog" "rand"
  "registerFlightPlanDelegate" "removecommand" "removelistener" "resolvepath"
  "setlistener" "_setlistener" "setprop" "srand" "systime" "thisfunc"
  "tileIndex" "tilePath" "values"
] @function

;; Timer properties
[
  "singleShot" "isRunning" "simulatedTime"
] @variable.special

;; Constants
[
  "D2R" "FPS2KT" "FT2M" "GAL2L" "IN2M" "KG2LB" "KT2FPS" "KT2MPS"
  "LG2GAL" "LB2KG" "M2FT" "M2IN" "M2NM" "MPS2KT" "NM2M" "R2D"
] @constant

;; Math module
(identifier) @function.method
  (#match? @function.method "^(abs|acos|asin|atan2|avg|ceil|clamp|cos|exp|floor|fmod|in|log10|max|min|mod|periodic|pow|round|sin|sgn|sqrt|tan)$")

(identifier) @constant
  (#match? @constant "^(e|pi)$")

(identifier) @type
  (#match? @type "^(math)$")

;; Props module
(identifier) @function.method
  (#match? @function.method "^(new|addChild|addChildren|alias|clearValue|equals|getAliasTarget|getAttribute|getBoolValue|getChild|getChildren|getIndex|getName|getNode|getParent|getPath|getType|getValue|getValues|initNode|remove|removeAllChildren|removeChild|removeChildren|setAttribute|setBoolValue|setDoubleValue|setIntValue|setValue|setValues|unalias|compileCondition|condition|copy|dump|getNode|nodeList|runBinding|setAll|wrap|wrapNode)$")

(identifier) @type
  (#match? @type "^(Node)$")

(identifier) @variable.special
  (#match? @variable.special "^(props|globals)$")

;; Clipboard module
(identifier) @function.method
  (#match? @function.method "^(getText|setText)$")

(identifier) @type
  (#match? @type "^(clipboard)$")

(identifier) @constant
  (#match? @constant "^(CLIPBOARD|SELECTION)$")

;; Debug module
(identifier) @function.method
  (#match? @function.method "^(attributes|backtrace|bt|benchmark|benchmark_time|dump|isnan|local|print_rank|printerror|propify|proptrace|rank|string|tree|warn|new|enable|disable|getHits|hit)$")

(identifier) @type
  (#match? @type "^(debug|Breakpoint)$")

;; Geo module
(identifier) @function.method
  (#match? @function.method "^(new|set|set_lat|set_lon|set_alt|set_latlon|set_x|set_y|set_z|set_xyz|lat|lon|alt|latlon|x|y|z|xyz|is_defined|dump|course_to|distance_to|direct_distance_to|apply_course_distance|test|update|_equals|aircraft_position|click_position|elevation|format|normdeg|normdeg180|put_model|tile_index|tile_path|viewer_position)$")

(identifier) @type
  (#match? @type "^(geo|PositionedSearch|Coord)$")

(identifier) @constant
  (#match? @constant "^(ERAD)$")

;; IO module
(identifier) @function.method
  (#match? @function.method "^(basename|close|dirname|flush|include|load_nasal|open|read|read_airport_properties|read_properties|readfile|readln|readxml|seek|stat|tell|write|write_properties|writexml)$")

(identifier) @type
  (#match? @type "^(io)$")

(identifier) @constant
  (#match? @constant "^(SEEK_CUR|SEEK_END|SEEK_SET)$")

;; OS Path module
(identifier) @function.method
  (#match? @function.method "^(new|set|append|concat|exists|canRead|canWrite|isFile|isDir|isRelative|isAbsolute|isNull|create_dir|remove|rename|realpath|file|dir|base|file_base|extension|lower_extension|complete_lower_extension|str|mtime)$")

(identifier) @type
  (#match? @type "^(os\\.path)$")module.exports = grammar({
    name: 'nasal',

    extras: $ => [
      /\s/,
      $.comment,
    ],

    word: $ => $.identifier,

    conflicts: $ => [
      [$._empty_block, $._empty_hash],
      [$.expression_statement, $.function_definition],
      [$.assignment_expression, $.binary_expression],
    ],

    precedences: $ => [
      [
        'member',
        'call',
        'unary',
        'binary_mult',
        'binary_add',
        'binary_comp',
        'binary_bitwise_and',
        'binary_bitwise_xor',
        'binary_bitwise_or',
        'binary_and',
        'binary_or',
        'null_chain',
        'ternary',
        'assignment',
        'tuple',
      ],
    ],

    rules: {
      source_file: $ => repeat($._statement),

      _statement: $ => choice(
        $.expression_statement,
        $.use_statement,
        $.variable_declaration,
        $.function_definition,
        $.if_statement,
        $.for_statement,
        $.foreach_statement,
        $.forindex_statement,
        $.while_statement,
        $.return_statement,
        $.break_statement,
        $.continue_statement,
        $.multi_assignment,
        $.block
      ),

      expression_statement: $ => seq(
        $._expression,
        optional(';')
      ),

      use_statement: $ => seq(
        'use',
        field('path', seq(
          $.identifier,
          repeat(seq('.', $.identifier))
        )),
        optional(';')
      ),

      variable_declaration: $ => seq(
        'var',
        field('name', choice(
          $.identifier,
          $.multi_identifier
        )),
        '=',
        field('value', choice(
          $._expression,
          $.tuple
        )),
        optional(';')
      ),

      multi_identifier: $ => seq(
        '(',
        commaSep1($.identifier),
        ')'
      ),

      tuple: $ => prec.right('tuple', seq(
        '(',
        commaSep1($._expression),
        ')'
      )),

      multi_assignment: $ => seq(
        field('left', $.tuple),
        '=',
        field('right', choice(
          $._expression,
          $.tuple
        )),
        optional(';')
      ),

      function_definition: $ => seq(
        'func',
        optional(field('name', $.identifier)),
        field('parameters', $.parameter_list),
        field('body', $.block)
      ),

      parameter_list: $ => seq(
        '(',
        optional(commaSep($.parameter)),
        ')'
      ),

      parameter: $ => seq(
        field('name', $.identifier),
        optional(seq(
          '=',
          field('default_value', $._expression)
        )),
        optional('...')
      ),

      if_statement: $ => seq(
        'if',
        field('condition', seq('(', $._expression, ')')),
        field('consequence', $.block),
        repeat(field('alternative', $.elsif_clause)),
        optional(field('alternative', $.else_clause))
      ),

      elsif_clause: $ => seq(
        'elsif',
        field('condition', seq('(', $._expression, ')')),
        field('consequence', $.block)
      ),

      else_clause: $ => seq(
        'else',
        field('consequence', $.block)
      ),

      for_statement: $ => seq(
        'for',
        '(',
        field('initializer', optional(choice(
          $.variable_declaration,
          $._expression
        ))),
        ';',
        field('condition', optional($._expression)),
        ';',
        field('increment', optional($._expression)),
        ')',
        field('body', $.block)
      ),

      foreach_statement: $ => seq(
        'foreach',
        '(',
        field('variable', choice(
          $.identifier,
          seq('var', $.identifier),
          $.call_expression
        )),
        ';',
        field('collection', $._expression),
        ')',
        field('body', $.block)
      ),

      forindex_statement: $ => seq(
        'forindex',
        '(',
        field('variable', choice(
          $.identifier,
          seq('var', $.identifier),
          $.call_expression
        )),
        ';',
        field('collection', $._expression),
        ')',
        field('body', $.block)
      ),

      while_statement: $ => seq(
        'while',
        field('condition', seq('(', $._expression, ')')),
        field('body', $.block)
      ),

      return_statement: $ => seq(
        'return',
        optional($._expression),
        optional(';')
      ),

      break_statement: $ => seq('break', optional(';')),
      continue_statement: $ => seq('continue', optional(';')),

      block: $ => choice(
        $._empty_block,
        seq(
          '{',
          repeat($._statement),
          '}'
        )
      ),

      _empty_block: $ => seq('{', '}'),

      _expression: $ => choice(
        $.nil_literal,
        $.boolean_literal,
        $.number_literal,
        $.string_literal,
        $.identifier,
        $.array_literal,
        $.hash_literal,
        $.function_expression,
        $.call_expression,
        $.binary_expression,
        $.unary_expression,
        $.ternary_expression,
        $.assignment_expression,
        $.member_expression,
        $.subscript_expression,
        $.null_coalescing_expression,
        $.parenthesized_expression,
      ),

      nil_literal: $ => 'nil',
      boolean_literal: $ => choice('true', 'false'),
      number_literal: $ => choice(
        /[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?/,
        /0[xX][0-9a-fA-F]+/
      ),

      string_literal: $ => choice(
        seq(
          '"',
          repeat(choice(
            token.immediate(prec(1, /[^"\\]+/)),
            $.escaped_character
          )),
          '"'
        ),
        seq(
          "'",
          repeat(choice(
            token.immediate(prec(1, /[^'\\]+/)),
            $.escaped_character
          )),
          "'"
        )
      ),

      escaped_character: $ => token.immediate(seq(
        '\\',
        choice(
          /[0-7]{1,3}/,
          /x[0-9a-fA-F]{2}/,
          /['"\\abfnrtv]/,
          /./
        )
      )),

      identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

      array_literal: $ => seq(
        '[',
        optional(commaSep($._expression)),
        ']'
      ),

      hash_literal: $ => choice(
        $._empty_hash,
        seq(
          '{',
          commaSep1($.hash_pair),
          '}'
        )
      ),

      _empty_hash: $ => seq('{', '}'),

      hash_pair: $ => seq(
        field('key', choice($.identifier, $.string_literal)),
        ':',
        field('value', $._expression)
      ),

      function_expression: $ => seq(
        'func',
        field('parameters', $.parameter_list),
        field('body', $.block)
      ),

      call_expression: $ => prec.left('call', seq(
        field('function', $._expression),
        field('calls', repeat1(choice(
          $.function_call,
          $.vector_call,
          $.hash_call,
          $.null_access_call
        )))
      )),

      function_call: $ => seq(
        '(',
        optional(choice(
          commaSep($._expression),
          commaSep($.hash_pair)
        )),
        ')'
      ),

      vector_call: $ => seq(
        '[',
        commaSep1($.slice),
        ']'
      ),

      // Fixed slice rule that doesn't match the empty string
      slice: $ => choice(
        $._expression, // just an index
        seq($._expression, ':'), // begin:
        seq(':', $._expression), // :end
        seq($._expression, ':', $._expression) // begin:end
      ),

      hash_call: $ => seq(
        '.',
        field('property', $.identifier)
      ),

      null_access_call: $ => seq(
        '?.',
        field('property', $.identifier)
      ),

      binary_expression: $ => choice(
        // Concatenation
        prec.left('binary_add', seq(
          field('left', $._expression),
          '..',
          field('right', $._expression)
        )),
        // Multiplication, division
        prec.left('binary_mult', seq(
          field('left', $._expression),
          field('operator', choice('*', '/')),
          field('right', $._expression)
        )),
        // Addition, subtraction, concat
        prec.left('binary_add', seq(
          field('left', $._expression),
          field('operator', choice('+', '-', '~')),
          field('right', $._expression)
        )),
        // Comparison operators
        prec.left('binary_comp', seq(
          field('left', $._expression),
          field('operator', choice('<', '<=', '>', '>=', '==', '!=')),
          field('right', $._expression)
        )),
        // Bitwise and
        prec.left('binary_bitwise_and', seq(
          field('left', $._expression),
          '&',
          field('right', $._expression)
        )),
        // Bitwise xor
        prec.left('binary_bitwise_xor', seq(
          field('left', $._expression),
          '^',
          field('right', $._expression)
        )),
        // Bitwise or
        prec.left('binary_bitwise_or', seq(
          field('left', $._expression),
          '|',
          field('right', $._expression)
        )),
        // Logical and
        prec.left('binary_and', seq(
          field('left', $._expression),
          'and',
          field('right', $._expression)
        )),
        // Logical or
        prec.left('binary_or', seq(
          field('left', $._expression),
          'or',
          field('right', $._expression)
        ))
      ),

      null_coalescing_expression: $ => prec.left('null_chain', seq(
        field('left', $._expression),
        '??',
        field('right', $._expression)
      )),

      ternary_expression: $ => prec.right('ternary', seq(
        field('condition', $._expression),
        '?',
        field('consequence', $._expression),
        ':',
        field('alternative', $._expression)
      )),

      unary_expression: $ => prec.right('unary', seq(
        field('operator', choice('-', '!', '~')),
        field('argument', $._expression)
      )),

      parenthesized_expression: $ => seq(
        '(',
        $._expression,
        ')'
      ),

      member_expression: $ => prec.left('member', seq(
        field('object', $._expression),
        '.',
        field('property', $.identifier)
      )),

      subscript_expression: $ => prec.left('member', seq(
        field('object', $._expression),
        '[',
        field('index', $._expression),
        ']'
      )),

      assignment_expression: $ => prec.right('assignment', seq(
        field('left', choice(
          $.identifier,
          $.member_expression,
          $.subscript_expression
        )),
        field('operator', choice(
          '=', '+=', '-=', '*=', '/=', '~=',
          '&=', '|=', '^='
        )),
        field('right', $._expression)
      )),

      comment: $ => token(seq('#', /.*/)),
    }
  });

  function commaSep(rule) {
    return optional(commaSep1(rule));
  }

  function commaSep1(rule) {
    return seq(rule, repeat(seq(',', rule)), optional(','));
  }
  ```

  The key change is in the `slice` rule:

  ```javascript
  // OLD (matches empty string)
  slice: $ => seq(
    optional($._expression),
    optional(seq(':', optional($._expression)))
  )

  // NEW (doesn't match empty string)
  slice: $ => choice(
    $._expression, // just an index
    seq($._expression, ':'), // begin:
    seq(':', $._expression), // :end
    seq($._expression, ':', $._expression) // begin:end
  )

;; GUI module
(identifier) @function.method
  (#match? @function.method "^(popupTip|showDialog|menuEnable|menuBind|setCursor|findElementByName|fpsDisplay|latencyDisplay|popdown|set|setColor|setFont|setBinding|state|del|load|toggle|is_open|reinit|rescan|select|next|previous|set_title|set_button|set_directory|set_file|set_dotfiles|set_pattern|save_flight|load_flight|set_screenshotdir|property_browser|dialog_apply|dialog_update|enable_widgets|nextStyle|setWeight|setWeightOpts|weightChangeHandler|showWeightDialog|showHelpDialog)$")

(identifier) @type
  (#match? @type "^(gui|Widget|Dialog|OverlaySelector|FileSelector|DirSelector)$")
