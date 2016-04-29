Byte      = mojs.Transit
Transit   = mojs.Transit
Bit       = mojs.shapesMap.getShape('bit')
Thenable  = mojs.Thenable
Tweenable = mojs.Tweenable
Rect = mojs.shapesMap.getShape('rect')
h    = mojs.helpers
ns   = 'http://www.w3.org/2000/svg'
svg  = document.createElementNS?(ns, 'svg')

# console.log   = ->
console.warn  = ->
console.error = ->

describe 'Transit ->', ->
  describe '_vars method', ->
    it 'should have own _vars function ->', ->
      byte = new Byte
      expect(byte._vars).toBeDefined()
      expect(-> byte._vars()).not.toThrow()
    it 'should call _vars super method', ->
      byte = new Byte
      expect(byte._history.length).toBe 1

  describe 'extension ->', ->
    it 'should extend Tweenable class', ->
      byte = new Byte
      expect(byte instanceof Tweenable).toBe(true)
    it 'should extend Thenable class', ->
      byte = new Byte
      expect(byte instanceof Thenable).toBe(true)
  describe 'defaults object ->', ->
    it 'should have defaults object', ->
      byte = new Byte
      expect(byte._defaults).toBeDefined()
      expect(byte._defaults.parent).toBe           document.body
      expect(byte._defaults.shape).toBe            'circle'
      expect(byte._defaults.stroke).toBe           'transparent'
      expect(byte._defaults.strokeOpacity).toBe    1
      expect(byte._defaults.strokeLinecap).toBe    ''
      expect(byte._defaults.strokeWidth).toBe      2
      expect(byte._defaults.strokeDasharray).toBe  0
      expect(byte._defaults.strokeDashoffset).toBe 0
      expect(byte._defaults.fill).toBe             'deeppink'
      expect(byte._defaults.fillOpacity).toBe      1
      expect(byte._defaults.left).toBe             0
      expect(byte._defaults.top).toBe              0
      expect(byte._defaults.x).toBe                0
      expect(byte._defaults.y).toBe                0
      expect(byte._defaults.angle).toBe            0
      expect(byte._defaults.scale).toBe            1
      expect(byte._defaults.scaleX).toBe           null
      expect(byte._defaults.scaleY).toBe           null
      expect(byte._defaults.origin).toBe           '50% 50%'
      expect(byte._defaults.rx).toBe               0
      expect(byte._defaults.ry).toBe               0
      expect(byte._defaults.opacity).toBe          1
      expect(byte._defaults.points).toBe           3
      expect(byte._defaults.duration).toBe         400
      expect(byte._defaults.radius[0]).toBe        50
      expect(byte._defaults.radiusX).toBe          null
      expect(byte._defaults.radiusY).toBe          null
      expect(byte._defaults.isShowEnd).toBe        true
      expect(byte._defaults.isShowStart).toBe      false
      expect(byte._defaults.size).toBe             null
      expect(byte._defaults.sizeGap).toBe          0
      expect(byte._defaults.callbacksContext).toBe byte
      expect(byte._defaults.prevChainModule).toBe  null

  describe '_applyCallbackOverrides ->', ->
    it 'should create callbackOverrides object on passed object', ->
      tr = new Transit
      obj = {}
      tr._applyCallbackOverrides(obj)
      expect(typeof obj.callbackOverrides).toBe 'object'
      # not null
      expect(obj.callbackOverrides).toBe obj.callbackOverrides

    describe 'onUpdate callback override ->', ->
      it 'should override this._o.onUpdate', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides(obj)
        expect(typeof obj.callbackOverrides.onUpdate).toBe 'function'
      it 'should call _setProgress ', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides(obj)
        spyOn tr, '_setProgress'
        progress = .25
        obj.callbackOverrides.onUpdate progress
        expect(tr._setProgress).toHaveBeenCalledWith progress
      it 'should not override onUpdate function if exists', ->
        isRightScope = null; args = null
        options = {
          easing: 'Linear.None',
          onUpdate:->
            isRightScope = @ is tr
            args = arguments
          }
        tr = new Transit options
        expect(typeof tr._o.onUpdate).toBe 'function'

        tr.timeline.setProgress 0
        tr.timeline.setProgress .1
        expect(isRightScope).toBe true

        expect(args[0]).toBe .1
        expect(args[1]).toBe .1
        expect(args[2]).toBe true
        expect(args[3]).toBe false

      it 'should call _setProgress method', ->
        options = { easing: 'Linear.None', onUpdate:-> }
        obj = {}
        tr = new Transit options

        tr.timeline.setProgress 0
        spyOn tr, '_setProgress'
        progress = .1
        tr.timeline.setProgress progress
        expect(tr._setProgress.calls.first().args[0]).toBeCloseTo progress, 5

    describe 'onStart callback override ->', ->
      it 'should override this._o.onStart', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        expect(typeof obj.callbackOverrides.onStart).toBe 'function'
      it 'should call _show if isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_show'
        obj.callbackOverrides.onStart true
        expect(tr._show).toHaveBeenCalled()
      it 'should call _hidePrevChainModule if isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hidePrevChainModule'
        obj.callbackOverrides.onStart true
        expect(tr._hidePrevChainModule).toHaveBeenCalled()
      it 'should call _hideModuleChain if isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hideModuleChain'
        obj.callbackOverrides.onStart true
        expect(tr._hideModuleChain).toHaveBeenCalled()
      it 'should call _hide if not isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hide'
        obj.callbackOverrides.onStart false
        expect(tr._hide).toHaveBeenCalled()
      it 'should call _showPrevChainModule if not isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_showPrevChainModule'
        obj.callbackOverrides.onStart false
        expect(tr._showPrevChainModule).toHaveBeenCalled()
      it 'should not call _hide if not isForward and !isShowStart', ->
        tr = new Transit isShowStart: true
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hide'
        obj.callbackOverrides.onStart false
        expect(tr._hide).not.toHaveBeenCalled()

      it 'should not call _hideModuleChain if !isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hideModuleChain'
        obj.callbackOverrides.onStart false
        expect(tr._hideModuleChain).not.toHaveBeenCalled()

    describe 'onComplete callback override ->', ->
      it 'should override this._o.onComplete', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        expect(typeof obj.callbackOverrides.onComplete).toBe 'function'
      it 'should call _show if !isForward', ->
        tr = new Transit
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_show'
        obj.callbackOverrides.onComplete false
        expect(tr._show).toHaveBeenCalled()
      it 'should call _hide if isForward', ->
        tr = new Transit isShowEnd: false
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hide'
        obj.callbackOverrides.onComplete true
        expect(tr._hide).toHaveBeenCalled()
      it 'should not call _hide if isForward but isShowEnd', ->
        tr = new Transit isShowEnd: true
        obj = {}
        tr._applyCallbackOverrides( obj )
        spyOn tr, '_hide'
        obj.callbackOverrides.onComplete true
        expect(tr._hide).not.toHaveBeenCalled()

  describe '_transformTweenOptions method', ->
    it 'should call _applyCallbackOverrides with _o', ->
      tr = new Transit
      spyOn tr, '_applyCallbackOverrides'
      tr._transformTweenOptions()
      expect(tr._applyCallbackOverrides).toHaveBeenCalledWith tr._o

  describe 'origin object ->', ->
    it 'should have origin object', ->
      byte = new Byte
      expect(byte._origin).toBeDefined()
      expect(typeof byte._origin).toBe 'object'
  describe 'options object ->', ->
    it 'should receive empty options object by default', ->
      byte = new Byte
      expect(byte._o).toBeDefined()
    it 'should receive options object', ->
      byte = new Byte option: 1
      expect(byte._o.option).toBe 1
  describe 'index option ->', ->
    it 'should receive index option', ->
      byte = new Transit index: 5
      expect(byte._index).toBe 5
    it 'should fallback to 0', ->
      byte = new Transit
      expect(byte._index).toBe 0
  describe 'options history ->', ->
    it 'should have history array', ->
      byte = new Byte
      expect(h.isArray(byte._history)).toBe true
    it 'should save options to history array', ->
      byte = new Byte radius: 20
      expect(byte._history.length).toBe 1
 
  describe 'size calculations ->', ->
    it 'should calculate size el size depending on largest value', ->
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 6:  4    }
      expect(byte._props.size).toBe(206)
    it 'should calculate size el size based on radiusX/Y', ->
      byte = new Byte
        radius:       { 25: -100 }
        radiusX:      200
        strokeWidth:  { 6:  4    }
      expect(byte._props.size).toBe(406)
    it 'should calculate size el size based on radiusX/Y', ->
      byte = new Byte
        radius:       { 25: -100 }
        radiusX:      200
        radiusY:      300
        strokeWidth:  { 6:  4    }
      expect(byte._props.size).toBe(606)
    it 'should calculate size el size based on radiusX/Y', ->
      byte = new Byte
        radius:       { 25: -100 }
        radiusY:      30
        strokeWidth:  { 6:  4    }
      expect(byte._props.size).toBe(206)
    it 'should calculate size el size based on radiusX/Y', ->
      byte = new Byte
        radius:       50
        radiusY:      30
        strokeWidth:  { 6:  4 }
      expect(byte._props.size).toBe(106)
    it 'should have sizeGap option', ->
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 6:  4    }
        sizeGap: 40
      expect(byte._props.size).toBe(286)
    it 'should calculate size el size depending on shape\'s ratio', ->
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 6:  4    }
        shape:        'rect'
      svg = document.createElementNS ns, 'svg'
      rect  = new Rect ctx: svg
      expect(byte._props.size).toBe(206)
    it 'should not calculate size el size if size was passed', ->
      byte = new Byte
        radius:       100
        strokeWidth:  5
        size: 400
      expect(byte._props.size).toBe(400)
    it 'should not calculate size el size if external context was passed', ->
      byte = new Byte
        radius:       100
        strokeWidth:  5
        size:         400
        ctx:          svg
      expect(byte._props.size).toBe(400)
    it 'should calculate center based on el size', ->
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 4:  6    }
      expect(byte._props.size)   .toBe(206)
      expect(byte._props.center) .toBe(103)
    it 'should increase size if elastic.out/inout easing', ->
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 4:  6    }
        easing: 'Elastic.Out'
      expect(byte._props.size)   .toBe(206*1.25)
      expect(byte._props.center) .toBe(byte._props.size/2)
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 4:  6    }
        easing: 'Elastic.InOut'
      expect(byte._props.size)   .toBe(206*1.25)
      expect(byte._props.center) .toBe(byte._props.size/2)
    it 'should increase size if back.out/inout easing', ->
      byte = new Byte
        isIt: 1
        radius:       { 25: -100 }
        strokeWidth:  { 4:  6 }
        easing: 'back.Out'
      expect(byte._props.size)   .toBe(206*1.1)
      expect(byte._props.center) .toBe(byte._props.size/2)
      byte = new Byte
        radius:       { 25: -100 }
        strokeWidth:  { 4:  6    }
        easing: 'Back.InOut'
      expect(byte._props.size)   .toBe(206*1.1)
      expect(byte._props.center) .toBe(byte._props.size/2)
  
  describe 'el creation ->', ->
    it 'should create wrapperEl', ->
      byte = new Byte radius: 25
      expect(byte.wrapperEl.tagName.toLowerCase()).toBe('div')
      expect(byte.wrapperEl.style[ 'opacity' ]).toBe('0.99999')
      expect(byte.wrapperEl.getAttribute('data-name')).toBe('mojs-transit')
      # transform = byte.wrapperEl.style[ 'transform' ]
      # prefixedTransform = byte.wrapperEl.style[ "#{h.prefix.css}transform" ]
      # expect(transform or prefixedTransform).toBe('translate(0, 0)')

    it 'should not create wrapperEl if `prevChainModule` passed', ->
      byte = new Byte radius: 25, prevChainModule: new Byte
      expect(byte.wrapperEl).not.toBeDefined()

    it 'should create el', ->
      byte = new Byte radius: 25
      expect(byte.el.tagName.toLowerCase()).toBe('div')
    it 'should create context', ->
      byte = new Byte radius: 25
      expect(byte.el.firstChild.tagName.toLowerCase()).toBe('svg')
    it 'should set context styles', ->
      byte = new Byte radius: 25
      svg = byte.el.firstChild
      expect(svg.style.position)                .toBe 'absolute'
      expect(svg.style.width)                   .toBe '100%'
      expect(svg.style.height)                  .toBe '100%'
      expect(parseInt(svg.style.left, 10))      .toBe 0
      expect(parseInt(svg.style.top, 10))       .toBe 0
    it 'should not create context and el if context was passed', ->
      svg.isSvg = true
      byte = new Byte ctx: svg
      expect(byte.el)           .toBe byte.bit.el
      expect(byte.ctx)          .toBeDefined()
      expect(byte.ctx.isSvg)    .toBe true
    it 'should set el size', ->
      byte = new Byte
        radius:       25
        strokeWidth:  2
        x:            10
        y:            20
      expect(byte.el.style.position)              .toBe 'absolute'
      expect(byte.el.style.width)                 .toBe '52px'
      expect(byte.el.style.height)                .toBe '52px'
      expect(byte.el.style.display)               .toBe 'none'
      expect(byte.el.style['margin-left'])        .toBe '-26px'
      expect(byte.el.style['margin-top'])         .toBe '-26px'
      expect(byte.el.style['marginLeft'])         .toBe '-26px'
      expect(byte.el.style['marginTop'])          .toBe '-26px'
      #expect(byte.el.style['backface-visibility']).toBe 'hidden'
      #expect(byte.el.style["#{h.prefix.css}backface-visibility"]).toBe 'hidden'
      expect(byte._isShown).toBe false
    it 'should skip props if foreign context', ->
      byte = new Byte
        radius:       25
        strokeWidth:  2
        x:            10
        y:            20
        ctx: svg
      expect(byte.el.style.display)               .toBe 'none'
      expect(byte.el.style.opacity)               .toBe '1'
      expect(byte.el.style.position)              .not.toBe 'absolute'
      expect(byte.el.style.width)                 .not.toBe '54px'
      expect(byte.el.style.height)                .not.toBe '54px'
      expect(byte.el.style['margin-left'])        .not.toBe '-26px'
      expect(byte.el.style['margin-top'])         .not.toBe '-26px'
      expect(byte.el.style['marginLeft'])         .not.toBe '-26px'
      expect(byte.el.style['marginTop'])          .not.toBe '-26px'
      # expect(byte.el.style['backface-visibility']).not.toBe 'hidden'
      # prefixedProp = "#{h.prefix.css}backface-visibility"
      # expect(byte.el.style[prefixedProp]).not.toBe 'hidden'
      expect(byte._isShown).toBe false
    it 'should set display: block if isShowStart was passed', ->
      byte = new Byte isShowStart: true
      expect(byte.el.style.display).toBe 'block'
      expect(byte._isShown).toBe true
    it 'should set el size', ->
    # it 'should set el size based on remBase', ->
      byte = new Byte
        radius:       25
        strokeWidth:  2
        x:            10
        y:            20
      byte.isRendered = false
      h.remBase = 8
      byte._render()
      h.remBase = 16
      expect(byte.el.style.position)              .toBe 'absolute'
      expect(byte.el.style.width)                 .toBe '52px'
      expect(byte.el.style.height)                .toBe '52px'
      expect(byte.el.style['margin-left'])        .toBe '-26px'
      expect(byte.el.style['margin-top'])         .toBe '-26px'
      expect(byte.el.style['marginLeft'])         .toBe '-26px'
      expect(byte.el.style['marginTop'])          .toBe '-26px'
      #expect(byte.el.style['backface-visibility']).toBe 'hidden'
      #expect(byte.el.style["#{h.prefix.css}backface-visibility"]).toBe 'hidden'
    it 'should create bit', ->
      byte = new Byte radius: 25
      expect(byte.bit).toBeDefined()
      expect(byte.bit._o.isDrawLess).toBe true
    it 'should create bit based on shape option or fallback to circle', ->
      byte = new Byte
        radius:  25
        shape:   'rect'
      byte2 = new Byte radius: 25
      expect(byte.bit._props.shape).toBe  'rect'
      expect(byte2.bit._props.shape).toBe 'ellipse'

    it 'should add itself to parent if the option was passed', ->
      div  = document.createElement?('div')
      byte = new Byte
        radius: 25
        parent: div
        prevChainModule: new Byte

      expect(byte.el.parentNode).toBe div

    it 'should add itself to wrapperEl if `prevChainModule`', ->
      div  = document.createElement?('div')
      byte = new Byte
        radius:          25
        parent:          div
      expect(byte.el.parentNode).toBe byte.wrapperEl
      expect(byte.wrapperEl.parentNode).toBe div

  describe 'opacity set ->', ->
    it 'should set a position with respect to units', ->
      byte = new Byte opacity: .5
      expect(byte.el.style.opacity).toBe '0.5'
    it 'should animate opacity', (dfr)->
      byte = new Byte
        opacity:    { 1: 0}
        duration:   100
        onComplete:->
          expect(byte.el.style.opacity).toBe('0');
          dfr()
      byte.play()

  describe 'position set ->', ->
    describe 'x/y coordinates ->', ->
      it 'should set a position with respect to units', ->
        byte = new Byte left: 100, top: 50
        expect(byte.el.style.left).toBe '100px'
        expect(byte.el.style.top) .toBe '50px'
      it 'should animate position', (dfr)->
        byte = new Byte
          left: {100: '200px'}
          duration: 100
          onComplete:-> expect(byte.el.style.left).toBe('200px'); dfr()
        byte.play()
      it 'should warn when x/y animated position and not foreign context',->
        spyOn console, 'warn'
        byte = new Byte left: {100: '200px'}
        byte.play()
        expect(console.warn).toHaveBeenCalled()
      it 'should notwarn when x/y animated position and foreign context',->
        spyOn console, 'warn'
        byte = new Byte left: {100: '200px'}, ctx: svg
        byte.play()
        expect(console.warn).not.toHaveBeenCalled()
      it 'should animate position with respect to units', (dfr)->
        byte = new Byte
          left: {'20%': '50%'}
          duration: 100
        byte.play()
        setTimeout ->
          expect(byte.el.style.left)   .toBe '50%'
          dfr()
        , 500
      it 'end unit that were not specified should fallback to start unit', ()->
        byte = new Byte
          left: {'20%': 50}
          duration: 200
        byte.play()
        expect(byte._deltas.left.start.unit).toBe '%'
        expect(byte._deltas.left.end.unit)  .toBe '%'
      it 'should fallback to end units if units are different', (dfr)->
        byte = new Byte
          left: {'20%': '50px'}
          duration: 200
          onComplete:-> expect(byte.el.style.left).toBe('50px'); dfr()
        byte.play()
      it 'should set a position with respect to units', ->
        byte = new Byte
          x: 100
          y: 50
        s = byte.el.style
        tr = s.transform or s["#{mojs.h.prefix.css}transform"]
        expect(tr).toBe 'scale(1, 1) translate(100px, 50px) rotate(0deg)'
      it 'should animate shift position', (dfr)->
        byte = new Byte
          x: {100: '200px'}
          duration: 200
          onComplete:->
            s = byte.el.style
            tr = s.transform or s["#{mojs.h.prefix.css}transform"]
            isTr  = tr is 'scale(1, 1) translate(200px, 0) rotate(0deg)'
            isTr2 = tr is 'scale(1, 1) translate(200px, 0px) rotate(0deg)'
            expect(isTr or isTr2).toBe true
            dfr()
        byte.play()
      it 'should animate position with respect to units', (dfr)->
        byte = new Byte
          x: {'20%': '50%'}
          duration: 200
          onComplete:->
            s = byte.el.style
            tr = s.transform or s["#{mojs.h.prefix.css}transform"]
            isTr = tr is 'scale(1, 1) translate(50%, 0) rotate(0deg)'
            isTr2 = tr is 'scale(1, 1) translate(50%, 0px) rotate(0deg)'
            expect(isTr or isTr2).toBe true
            dfr()
        byte.play()
      it 'should fallback to end units if units are differnt', (dfr)->
        byte = new Byte
          x: { '20%': '50px' }
          y: { 0    : '50%'  }
          duration: 200
          onComplete:->
            s = byte.el.style
            tr = s.transform or s["#{mojs.h.prefix.css}transform"]
            expect(tr).toBe 'scale(1, 1) translate(50px, 50%) rotate(0deg)'
            dfr()
        byte.play()
  
  describe '_render method ->', ->
    it 'should call draw method', ->
      byte = new Byte radius: 25
      spyOn byte, '_draw'
      byte._render()
      expect(byte._draw).toHaveBeenCalled()
    it 'should call _setElStyles method', ->
      byte = new Byte radius: 25
      spyOn byte, '_setElStyles'
      byte._render()
      expect(byte._setElStyles).toHaveBeenCalled()
    it 'should call _createBit method', ->
      byte = new Byte radius: 25
      spyOn byte, '_createBit'
      byte.isRendered = false
      byte._render()
      expect(byte._createBit).toHaveBeenCalled()
    it 'should set isRendered to true method', ->
      byte = new Byte radius: 25
      expect(byte.isRendered).toBe true
      byte.isRendered = false; byte._render()
      expect(byte.isRendered).toBe true
    it 'should call _calcSize method', ->
      byte = new Byte radius: 25
      spyOn byte, '_calcSize'
      byte.isRendered = false
      byte._render()
      expect(byte._calcSize).toHaveBeenCalled()
    it 'should not create new el', ->
      byte = new Byte radius: 25
      cnt = document.body.children.length
      byte._render true
      expect(cnt).toBe document.body.children.length
  describe '_draw method ->', ->
    # nope
    # it 'should call _setProp method', ->
    #   byte = new Byte radius: 25
    #   spyOn byte.bit, 'setProp'
    #   byte._draw()
    #   expect(byte.bit.setProp).toHaveBeenCalled()
    it 'should set all attributes to shape\'s properties', ->
      byte = new Byte
        radius: 25,
        x: 20, y: 30,
        rx: 15, ry: 25
        stroke:           'red'
        strokeWidth:      2
        strokeOpacity:    .5
        strokeLinecap:    'round'
        strokeDasharray:  200
        strokeDashoffset: 100
        fill:             'cyan'
        fillOpacity:      .5
        radius:           100
        radiusX:          22
        radiusY:          { 20: 0 }
        points:           4

      byte._draw()
      expect(byte.bit._props.x).toBe byte._origin.x
      expect(byte.bit._props.y).toBe byte._origin.y
      expect(byte.bit._props.rx).toBe byte._props.rx
      expect(byte.bit._props.ry).toBe byte._props.ry
      expect(byte.bit._props.stroke).toBe byte._props.stroke
      expect(byte.bit._props['stroke-width']).toBe byte._props.strokeWidth
      expect(byte.bit._props['stroke-opacity']).toBe byte._props.strokeOpacity
      expect(byte.bit._props['stroke-linecap']).toBe byte._props.strokeLinecap
      expect(byte.bit._props['stroke-dasharray']).toBe byte._props.strokeDasharray[0].value + ' '
      expect(byte.bit._props['stroke-dashoffset']).toBe byte._props.strokeDashoffset[0].value + ' '
      expect(byte.bit._props['fill']).toBe byte._props.fill
      expect(byte.bit._props['fill-opacity']).toBe byte._props.fillOpacity
      expect(byte.bit._props['radius']).toBe byte._props.radius
      expect(byte.bit._props['radiusX']).toBe byte._props.radiusX
      expect(byte.bit._props['radiusY']).toBe byte._props.radiusY
      expect(byte.bit._props['points']).toBe byte._props.points
      # old
      # expect(byte.bit._props['transform']).toBe byte._calcShapeTransform()

    it 'should set x/y to center', ->
      byte = new Byte radius: 25
      byte._draw()
      expect(byte.bit._props.x).toBe byte._props.center
      expect(byte.bit._props.y).toBe byte._props.center
    it 'should set x/y to props.x/props.y if context was passed', ->
      byte = new Byte radius: 25, ctx: svg
      byte._draw()
      expect(byte.bit._props.x).toBe parseFloat byte._props.x
      expect(byte.bit._props.y).toBe parseFloat byte._props.y
    it 'should call bit._draw method', ->
      byte = new Byte radius: 25
      spyOn byte.bit, 'draw'
      byte._draw()
      expect(byte.bit.draw).toHaveBeenCalled()
    it 'should call _drawEl method', ->
      byte = new Byte radius: 25
      spyOn byte, '_drawEl'
      byte._draw()
      expect(byte._drawEl).toHaveBeenCalled()
    it 'should receive the current progress', ->
      byte = new Byte radius: 25
      spyOn byte, '_draw'
      byte._setProgress .5
      expect(byte._draw).toHaveBeenCalledWith .5
  describe '_drawEl method ->', ->
    it 'should set el positions and transforms', ->
      byte = new Byte radius: 25, top: 10
      expect(byte.el.style.top)       .toBe     '10px'
      expect(byte.el.style.opacity)   .toBe     '1'
      expect(parseInt(byte.el.style.left, 10)).toBe 0
      s = byte.el.style
      tr = s.transform or s["#{mojs.h.prefix.css}transform"]
      isTr  = tr is 'scale(1, 1) translate(0, 0) rotate(0deg)'
      isTr2 = tr is 'scale(1, 1) translate(0px, 0px) rotate(0deg)'
      expect(isTr or isTr2).toBe true
    it 'should set only opacity if foreign context', ->
      byte = new Byte radius: 25, top: 10, ctx: svg
      byte._draw()
      expect(byte.el.style.opacity)   .toBe         '1'
      expect(byte.el.style.left)      .not.toBe     '0px'
      expect(byte.el.style.top)       .not.toBe     '10px'
      s = byte.el.style
      tr = if s.transform? then s.transform
      else s["#{mojs.h.prefix.css}transform"]
      expect(tr).toBeFalsy()
    it 'should set new values', ->
      byte = new Byte radius: 25, top: 10
      byte._draw()
      byte._props.left = '1px'
      byte._draw()
      expect(byte.el.style.left)      .toBe     '1px'
      expect(byte._lastSet.left.value) .toBe     '1px'
    it 'should not set old values', ->
      byte = new Byte radius: 25, y: 10
      byte._draw()
      byte._draw()
      expect(byte._lastSet.x.value)   .toBe    '0'
      expect(parseInt(byte.el.style.left, 10)).toBe 0
    it 'should return true if there is no el', ->
      byte = new Byte radius: 25
      byte.el = null
      expect(byte._drawEl()).toBe true
    it 'should set transform if angle changed', ->
      byte = new Byte angle: 25
      byte._draw()
      byte._props.angle = 26
      byte._draw()
      style = byte.el.style
      tr = style['transform'] or style["#{mojs.h.prefix.css}transform"]
      isTr = tr is 'scale(1, 1) translate(0, 0) rotate(26deg)'
      isTr2 = tr is 'scale(1, 1) translate(0px, 0px) rotate(26deg)'
      expect(isTr or isTr2).toBe true
      # expect(byte.el.style["#{h.prefix.css}transform"]).toBe resultStr
    it 'should not set transform if angle changed', ->
      byte = new Byte angle: 25
      byte._draw()
      spyOn byte, '_fillTransform'
      byte._draw()
      expect(byte._fillTransform).not.toHaveBeenCalled()
    it 'should set transform if scaleX changed', ->
      byte = new Byte scaleX: 25
      byte._draw()
      spyOn byte, '_fillTransform'
      byte._props.scaleX = 24
      byte._draw()
      expect(byte._fillTransform).toHaveBeenCalled()
    it 'should not set transform if scaleX not changed', ->
      byte = new Byte scaleX: 25
      byte._draw()
      spyOn byte, '_fillTransform'
      byte._draw()
      expect(byte._fillTransform).not.toHaveBeenCalled()
    it 'should set transform if scaleY changed', ->
      byte = new Byte scaleY: 25
      byte._draw()
      spyOn byte, '_fillTransform'
      byte._props.scaleY = 24
      byte._draw()
      expect(byte._fillTransform).toHaveBeenCalled()
    it 'should not set transform if scaleY not changed', ->
      byte = new Byte scaleY: 25
      byte._draw()
      spyOn byte, '_fillTransform'
      byte._draw()
      expect(byte._fillTransform).not.toHaveBeenCalled()
    it 'should set transform if one of the x, y or scale changed', ->
      byte = new Byte radius: 25, top: 10, ctx: svg
      byte._draw()
      spyOn byte, '_fillTransform'
      byte._draw()
      expect(byte._fillTransform).not.toHaveBeenCalled()
    it 'should set transform if x changed #1', ->
      byte = new Byte radius: 25, top: 10, x: { 0: 10 }
      byte._props.x = '4px'
      spyOn(byte, '_fillTransform').and.callThrough()
      byte._draw()
      expect(byte._fillTransform).toHaveBeenCalled()
      style = byte.el.style
      tr = style['transform'] or style["#{mojs.h.prefix.css}transform"]
      isTr = tr is 'scale(1, 1) translate(4px, 0) rotate(0deg)'
      isTr2 = tr is 'scale(1, 1) translate(4px, 0px) rotate(0deg)'
      expect(isTr or isTr2).toBe true

    it 'should set transform if x changed #2', ->
      byte = new Byte radius: 25, top: 10, y: { 0: 10 }
      byte._props.y = '4px'
      spyOn(byte, '_fillTransform').and.callThrough()
      byte._draw()
      expect(byte._fillTransform).toHaveBeenCalled()
      style = byte.el.style
      tr = style['transform'] or style["#{mojs.h.prefix.css}transform"]
      isTr = tr is 'scale(1, 1) translate(0, 4px) rotate(0deg)'
      isTr2 = tr is 'scale(1, 1) translate(0px, 4px) rotate(0deg)'
      expect(isTr or isTr2).toBe true

    it 'should set transform if x changed #3', ->
      byte = new Byte radius: 25, top: 10, scale: { 0: 10 }
      byte._props.scale = 3
      spyOn(byte, '_fillTransform').and.callThrough()
      byte._draw()
      expect(byte._fillTransform).toHaveBeenCalled()
      # resultStr = 'scale(3) translate(0, 0) rotate(0deg)'
      # expect(byte.el.style['transform']).toBe resultStr
      style = byte.el.style
      tr = style['transform'] or style["#{mojs.h.prefix.css}transform"]
      isTr = tr is 'scale(3, 3) translate(0, 0) rotate(0deg)'
      isTr2 = tr is 'scale(3, 3) translate(0px, 0px) rotate(0deg)'
      expect(isTr or isTr2).toBe true

    it 'should set `transform-origin` if `origin`', ->
      byte = new Byte origin: '50% 30%'
      byte._drawEl()
      prop = 'transform-origin'
      style = byte.el.style
      tr = style[ prop ] or style["#{mojs.h.prefix.css}#{prop}"]
      expect(tr).toBe '50% 30% '

    it 'should set `transform-origin` if `origin` changed', ->
      byte = new Byte origin: '50% 30%'
      spyOn(byte, '_fillOrigin').and.callThrough()
      byte._props.origin = byte._parseStrokeDashOption( 'origin', '50% 40%');
      byte._drawEl()
      prop = 'transform-origin'
      style = byte.el.style
      tr = style[ prop ] or style["#{mojs.h.prefix.css}#{prop}"]
      expect(tr).toBe '50% 40% '
      expect(byte._fillOrigin).toHaveBeenCalled()

    it 'should not set `transform-origin` if `origin`', ->
      byte = new Byte origin: '50% 30%'
      byte._draw()
      spyOn(byte, '_fillOrigin').and.callThrough()
      byte._draw()
      expect(byte._fillOrigin).not.toHaveBeenCalled()

    it 'should set `transform-origin` if `origin` in `_deltas`', ->
      byte = new Byte origin: { '50% 30%': '50% 0'}
      spyOn(byte, '_fillOrigin').and.callThrough()
      byte._drawEl()
      byte._drawEl()
      expect(byte._fillOrigin.calls.count()).toBe 2
      
  describe '_isPropChanged method ->', ->
    it 'should return bool showing if prop was changed after the last set', ->
      byte = new Byte radius: 25, y: 10
      byte._props.left = '20px'
      expect(byte._isPropChanged 'left').toBe true
      byte._props.left = '20px'
      expect(byte._isPropChanged 'left').toBe false
    it 'should add prop object to lastSet if undefined', ->
      byte = new Byte radius: 25, y: 10
      byte._isPropChanged('x')
      expect(byte._lastSet.x).toBeDefined()
  describe 'delta calculations ->', ->
    it 'should skip delta for excludePropsDelta object', ->
      byte = new Byte radius: {45: 55}
      byte._skipPropsDelta = radius: 1
      byte._extendDefaults()
      expect(byte._deltas.radius).not.toBeDefined()
    describe 'numeric values ->', ->
      it 'should calculate delta', ->
        byte = new Byte radius:  {25: 75}
        radiusDelta = byte._deltas.radius
        expect(radiusDelta.start)   .toBe   25
        expect(radiusDelta.delta)   .toBe   50
        expect(radiusDelta.type)    .toBe   'number'
      it 'should calculate delta with string arguments', ->
        byte = new Byte radius:  {'25': '75'}
        radiusDelta = byte._deltas.radius
        expect(radiusDelta.start)   .toBe   25
        expect(radiusDelta.delta)   .toBe   50
      it 'should calculate delta with float arguments', ->
        byte = new Byte radius:  {'25.50': 75.50}
        radiusDelta = byte._deltas.radius
        expect(radiusDelta.start)   .toBe   25.5
        expect(radiusDelta.delta)   .toBe   50
      it 'should calculate delta with negative start arguments', ->
        byte = new Byte radius:  {'-25.50': 75.50}
        radiusDelta = byte._deltas.radius
        expect(radiusDelta.start)   .toBe   -25.5
        expect(radiusDelta.delta)   .toBe   101
      it 'should calculate delta with negative end arguments', ->
        byte = new Byte radius:  {'25.50': -75.50}
        radiusDelta = byte._deltas.radius
        expect(radiusDelta.start)   .toBe   25.5
        expect(radiusDelta.end)     .toBe   -75.5
        expect(radiusDelta.delta)   .toBe   -101
    describe 'color values ->', ->
      it 'should calculate color delta', ->
        byte = new Byte stroke:  {'#000': 'rgb(255,255,255)'}
        colorDelta = byte._deltas.stroke
        expect(colorDelta.start.r)    .toBe   0
        expect(colorDelta.end.r)      .toBe   255
        expect(colorDelta.delta.r)    .toBe   255
        expect(colorDelta.type)       .toBe   'color'
      it 'should ignore stroke-linecap prop, use start prop and warn', ->
        byte = null
        spyOn console, 'warn'
        fun = -> byte = new Byte strokeLinecap:  {'round': 'butt'}
        expect(-> fun()).not.toThrow()
        expect(console.warn).toHaveBeenCalled()
        expect(byte._deltas.strokeLinecap).not.toBeDefined()
    describe 'unit values ->', ->
      it 'should calculate unit delta', ->
        byte = new Byte x:  {'0%': '100%'}
        xDelta = byte._deltas.x
        expect(xDelta.start.string)    .toBe   '0'
        expect(xDelta.end.string)      .toBe   '100%'
        expect(xDelta.delta)           .toBe   100
        expect(xDelta.type)            .toBe   'unit'
    describe 'tween-related values ->', ->
      it 'should not calc delta for tween related props', ->
        byte = new Byte
          duration:  { 2000: 1000 }
         
        expect(byte._deltas.duration).not.toBeDefined()
  describe '_calcOrigin method ->', ->
    it "should set x and y to center by
        default (if no drawing context passed)", ->
      byte = new Byte radius:  {'25.50': -75.50}
      byte._calcOrigin .5
      expect(byte._origin.x).toBe byte._props.center
      expect(byte._origin.y).toBe byte._props.center
    it "should set x and y to x and y if drawing context passed", ->
      byte = new Byte radius:  {'25.50': -75.50}, ctx: svg
      byte._calcOrigin .5
      expect(byte._origin.x).toBe parseFloat byte._props.x
      expect(byte._origin.y).toBe parseFloat byte._props.y
  describe '_setProgress method ->', ->
    it 'should set transition progress', ->
      byte = new Byte radius:  {'25.50': -75.50}
      byte._setProgress .5
      expect(byte._progress).toBe .5
    it 'should set value progress', ->
      byte = new Byte radius:  {'25': 75}
      byte._setProgress .5
      expect(byte._props.radius).toBe 50
    it 'should call _calcOrigin method', ->
      byte = new Byte radius:  {'25': 75}
      spyOn byte, '_calcOrigin'
      byte._setProgress .5
      expect(byte._calcOrigin).toHaveBeenCalled()
    it 'should have origin object', ->
      byte = new Byte radius:  {'25': 75}
      byte._setProgress .5
      expect(byte._origin.x).toBeDefined()
      expect(byte._origin.y).toBeDefined()
    it 'should have origin should be the center of the transit', ->
      byte = new Byte radius:  {'25': 75}
      byte._setProgress .5
      expect(byte._origin.x).toBe byte._props.center
      expect(byte._origin.y).toBe byte._props.center
    it 'should have origin should be x/y if foreign context', ->
      byte = new Byte radius:{'25': 75}, ctx: svg
      byte._setProgress .5
      expect(byte._origin.x).toBe parseFloat byte._props.x
      expect(byte._origin.y).toBe parseFloat byte._props.x
    it 'should have origin should be number if foreign context', ->
      byte = new Byte radius:{'25': 75}, ctx: svg
      byte._setProgress .5
      expect(typeof byte._origin.x).toBe 'number'
      expect(typeof byte._origin.y).toBe 'number'
    it 'should call _calcCurrentProps', ->
      byte = new Byte radius:  {'25': 75}
      spyOn byte, '_calcCurrentProps'
      byte._setProgress .5
      expect(byte._calcCurrentProps).toHaveBeenCalledWith .5
    it 'not to thow', ->
      byte = new Byte radius:  {'25': 75}, ctx: svg
      expect(-> byte._show()).not.toThrow()
    it 'should set color value progress and only int', ->
      byte = new Byte stroke:  {'#000': 'rgb(255,255,255)'}
      colorDelta = byte._deltas.stroke
      byte._setProgress .5
      expect(byte._props.stroke).toBe 'rgba(127,127,127,1)'
    it 'should set color value progress for delta starting with 0', ->
      byte = new Byte stroke:  {'#000': 'rgb(0,255,255)'}
      colorDelta = byte._deltas.stroke
      byte._setProgress .5
      expect(byte._props.stroke).toBe 'rgba(0,127,127,1)'

  describe 'strokeDash.. values', ->
    it 'should set strokeDasharray/strokeDashoffset value progress', ->
      byte = new Byte strokeDasharray:  {'200 100': '400'}
      byte._setProgress .5
      expect(byte._props.strokeDasharray[0].value).toBe 300
      expect(byte._props.strokeDasharray[0].unit) .toBe 'px'
      expect(byte._props.strokeDasharray[1].value).toBe 50
      expect(byte._props.strokeDasharray[1].unit) .toBe 'px'
    it 'should set strokeDasharray/strokeDashoffset with percents', ->
      byte = new Byte
        type: 'circle'
        strokeDasharray:  {'0% 200': '100%'}
        radius: 100
      byte._setProgress .5
      expect(byte._props.strokeDasharray[0].value).toBe 50
      expect(byte._props.strokeDasharray[0].unit) .toBe '%'
      expect(byte._props.strokeDasharray[1].value).toBe 100
      expect(byte._props.strokeDasharray[1].unit) .toBe 'px'
    it 'should parse non-deltas strokeDasharray/strokeDashoffset values', ->
      byte = new Byte
        type: 'circle'
        strokeDasharray:  '100%'
        radius: 100
      expect(byte._props.strokeDasharray[0].value).toBe 100
      expect(byte._props.strokeDasharray[0].unit).toBe '%'
    it 'should parse multiple strokeDash.. values', ->
      byte = new Byte strokeDasharray: '7 100 7'
      expect(h.isArray(byte._props.strokeDasharray)).toBe true
      expect(byte._props.strokeDasharray.length).toBe 3
      expect(byte._props.strokeDasharray[0].value).toBe 7
      expect(byte._props.strokeDasharray[1].value).toBe 100
      expect(byte._props.strokeDasharray[2].value).toBe 7
    it 'should parse num values', ->
      byte = new Byte strokeDasharray: 7
      expect(h.isArray(byte._props.strokeDasharray)).toBe true
      expect(byte._props.strokeDasharray.length)    .toBe 1
  
  describe '_getRadiusSize method ->', ->
    it 'should return max from delatas if key is defined', ->
      byte = new Byte radiusX: 20: 30
      size = byte._getRadiusSize key: 'radiusX', fallback: 0
      expect(size).toBe 30
    it 'should return props\' value if delats\' one is not defined ', ->
      byte = new Byte radiusX: 20
      size = byte._getRadiusSize key: 'radiusX', fallback: 0
      expect(size).toBe 20
    it 'should fallback to passed fallback option', ->
      byte = new Byte
      size = byte._getRadiusSize key: 'radiusX', fallback: 0
      expect(size).toBe 0
    it 'should fallback to 0 by default', ->
      byte = new Byte
      size = byte._getRadiusSize key: 'radiusX'
      expect(size).toBe 0
  
  describe 'isForeign flag ->', ->
    it 'should not be set by default', ->
      byte = new Byte
      expect(byte.isForeign).toBe false
    it 'should be set if context was passed', ->
      byte = new Byte ctx: svg
      expect(byte.isForeign).toBe true
    it 'if context passed el should be bit\'s el', ->
      byte = new Byte ctx: svg
      expect(byte.el).toBe byte.bit.el

  describe 'foreign bit option ->', ->
    it 'should receive a foreign bit to work with', ->
      svg  = document.createElementNS?(ns, 'svg')
      bit  = document.createElementNS?(ns, 'rect')
      svg.appendChild bit

      byte = new Transit bit: bit
      expect(byte.bit.el).toBe bit

    it 'should set isForeignBit flag', ->
      svg  = document.createElementNS?(ns, 'svg')
      bit  = document.createElementNS?(ns, 'rect')
      svg.appendChild bit
      byte = new Byte bit: bit
      expect(byte.isForeignBit).toBe true
  describe '_increaseSizeWithEasing method ->', ->
    it 'should increase size based on easing - elastic.out', ->
      tr = new Transit easing: 'elastic.out'

      tr._props.size = 1
      tr._increaseSizeWithEasing()
      expect(tr._props.size).toBe 1.25

    it 'should increase size based on easing - elastic.inout', ->
      tr = new Transit easing: 'elastic.inout'

      tr._props.size = 1
      tr._increaseSizeWithEasing()
      expect(tr._props.size).toBe 1.25

    it 'should increase size based on easing - back.out', ->
      tr = new Transit easing: 'back.out'

      tr._props.size = 1
      tr._increaseSizeWithEasing()
      expect(tr._props.size).toBe 1.1

    it 'should increase size based on easing - back.inout', ->
      tr = new Transit easing: 'back.inout'

      tr._props.size = 1
      tr._increaseSizeWithEasing()
      expect(tr._props.size).toBe 1.1

  describe '_increaseSizeWithBitRatio method ->', ->
    it 'should increase size based on bit ratio', ->
      tr = new Transit shape: 'equal'

      tr._props.size = 1
      tr._increaseSizeWithBitRatio()
      expect(tr._props.size).toBe tr.bit._props.ratio

    it 'should increase size based 2 gap sizes', ->
      gap = 20
      tr = new Transit shape: 'equal', sizeGap: gap

      tr._props.size = 1
      tr._increaseSizeWithBitRatio()
      expect(tr._props.size).toBe tr.bit._props.ratio + 2*gap

  describe 'callbacksContext option ->', ->
    it 'should pass the options to the tween', ->
      obj = {}; isRightContext = null
      tr = new Transit
        callbacksContext: obj
        onUpdate:-> isRightContext = @ is obj
      
      tr.setProgress 0 
      tr.setProgress .1

      expect(isRightContext).toBe true

    it 'should pass the options to the timeline', ->
      obj = {}; isRightContext = null
      tr = new Transit
        callbacksContext: obj
        timeline: { onUpdate:-> isRightContext = @ is obj }
      
      tr.setProgress 0
      tr.setProgress .1

      expect(isRightContext).toBe true
  
  describe '_fillTransform method ->', ->
    it 'return tranform string of the el', ->
      tr = new Transit x: 100, y: 100, angle: 50, scaleX: 2, scaleY: 3
      expect(tr._fillTransform())
        .toBe 'scale(2, 3) translate(100px, 100px) rotate(50deg)'  

  describe '_fillOrigin method ->', ->
    it 'return tranform-origin string of the el', ->
      tr = new Transit x: 100, y: 100, origin: '50% 30%'
      expect(tr._fillOrigin()).toBe '50% 30% '

    it 'return tranform-origin string of the el with delta', ->
      tr = new Transit
        x: 100, y: 100,
        easing: 'liner.none',
        origin: { '0% 0%' : '50% 200%' }
      tr.setProgress 0
      tr.setProgress .5
      expect(tr._fillOrigin()).toBe '25% 100% '

  describe '_hidePrevChainModule method ->', ->
    it 'should hide prevChainModule', ->
      module = { _hide: -> }
      tr = new Transit prevChainModule: module

      spyOn tr._props.prevChainModule, '_hide'
      tr._hidePrevChainModule()
      expect(tr._props.prevChainModule._hide).toHaveBeenCalled()

    it 'should not throw', ->
      tr = new Transit
      fun = -> tr._hidePrevChainModule()
      expect(fun).not.toThrow()

  describe '_showPrevChainModule method ->', ->
    it 'should hide prevChainModule', ->
      module = { _show: -> }
      tr = new Transit prevChainModule: module

      spyOn tr._props.prevChainModule, '_show'
      tr._showPrevChainModule()
      expect(tr._props.prevChainModule._show).toHaveBeenCalled()

    it 'should not throw', ->
      tr = new Transit
      fun = -> tr._showPrevChainModule()
      expect(fun).not.toThrow()

  describe '_hideModuleChain method ->', ->
    it 'should hide all modules in chain', ->
      tr = new Transit()
        .then( fill: 'orange' )
        .then( fill: 'cyan' )
        .then( fill: 'yellow' )

      spyOn tr._modules[0], '_hide'
      spyOn tr._modules[1], '_hide'
      spyOn tr._modules[2], '_hide'
      spyOn tr._modules[3], '_hide'

      tr._hideModuleChain()

      expect(tr._modules[0]._hide).not.toHaveBeenCalled()
      expect(tr._modules[1]._hide).toHaveBeenCalled()
      expect(tr._modules[2]._hide).toHaveBeenCalled()
      expect(tr._modules[3]._hide).toHaveBeenCalled()




