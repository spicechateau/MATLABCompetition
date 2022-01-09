classdef TapeWorm < audioPlugin
    % Chorus Plugin with Lofi Aesthetic
    properties (Access = public)
        % Delay
        delayMs = 1;
        feedbackN = 0;
        Tri = false;
        % Mod
        depthN = 0;
        rate = 0.1;
        ModSt = false;
        % Random
        randomN = 0;
        smoothN = 0;
        % Tape
        inGain = 0;
        hiss = 0;
        SatOn = false;
        CompOn = false;
        % Plugin
        mix = 0;
        outGain = 0;
        Bypass = false;
    end

    properties (Access = private)
        chorusEffect;
    end

    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginGridLayout( ...
            'RowHeight',[20, 100, 20, 100, 20, 100], ...
            'ColumnWidth',[100, 100, 100, 100, 100], ...
            'Padding',[20,20,20,20]), ...
            'BackgroundColor', 'w',...
            ... % Delay Parameters
            audioPluginParameter('delayMs', ...
            'Style', 'rotaryknob', ...
            'Layout', [2, 1], ...
            'DisplayName', 'Delay Time', 'DisplayNameLocation','Above', ...
            'Label', 'Ms', ...
            'Mapping', {'lin', 1, 30}), ...
            audioPluginParameter('feedbackN', ...
            'Style', 'rotaryknob', ...
            'Layout', [4, 1], ...
            'DisplayName', 'Feedback', 'DisplayNameLocation','Above', ...
            'Label', '', ...
            'Mapping', {'lin', 0, 1}), ...
            audioPluginParameter('Tri', ...
            'Style', 'vtoggle', ...
            'Layout', [6, 1], ...
            'DisplayName', 'Tri', 'DisplayNameLocation', 'Above'), ...
            ... % Mod Parameters
            audioPluginParameter('depthN', ...
            'Style', 'rotaryknob', ...
            'Layout', [2, 2], ...
            'DisplayName', 'Modulation Depth', 'DisplayNameLocation','Above', ...
            'Label', '', ...
            'Mapping', {'lin', 0, 1}), ...
            audioPluginParameter('rate', ...
            'Style', 'rotaryknob', ...
            'Layout', [4, 2], ...
            'DisplayName', 'Modulation Rate', 'DisplayNameLocation','Above', ...
            'Label', 'Hz', ...
            'Mapping', {'log', 0.1, 20}), ...
            audioPluginParameter('ModSt', ...
            'Style', 'vtoggle', ...
            'Layout', [6, 2], ...
            'DisplayName', 'Stereo Modulation', 'DisplayNameLocation', 'Above'), ...
            ... % Random Parameters
            audioPluginParameter('randomN', ...
            'Style', 'rotaryknob', ...
            'Layout', [2, 3], ...
            'DisplayName', 'Random', 'DisplayNameLocation','Above', ...
            'Label', '', ...
            'Mapping', {'lin', 0, 1}), ...
            audioPluginParameter('smoothN', ...
            'Style', 'rotaryknob', ...
            'Layout', [4, 3], ...
            'DisplayName', 'Smooth', 'DisplayNameLocation','Above', ...
            'Label', '', ...
            'Mapping', {'lin', 0, 1}), ...
            ... % Tape Parameters
            audioPluginParameter('inGain', ...
            'Style', 'rotaryknob', ...
            'Layout', [4, 4], ...
            'DisplayName', 'Input Gain', 'DisplayNameLocation','Above', ...
            'Label', 'dB', ...
            'Mapping', {'lin', -12, 12}), ...
            audioPluginParameter('hiss', ...
            'Style', 'rotaryknob', ...
            'Layout', [2, 4], ...
            'DisplayName', 'Hiss', 'DisplayNameLocation','Above', ...
            'Label', '', ...
            'Mapping', {'lin', 0, 1}), ...
            audioPluginParameter('SatOn', ...
            'Style', 'vtoggle', ...
            'Layout', [6, 4], ...
            'DisplayName', 'Saturation', 'DisplayNameLocation', 'Above'), ...
            audioPluginParameter('CompOn', ...
            'Style', 'vtoggle', ...
            'Layout', [6, 3], ...
            'DisplayName', 'Compander', 'DisplayNameLocation', 'Above'), ...
            ... % Plugin Parameteres
            audioPluginParameter('mix', ...
            'Style', 'rotaryknob', ...
            'Layout', [2, 5], ...
            'DisplayName', 'Mix', 'DisplayNameLocation','Above', ...
            'Label', '', ...
            'Mapping', {'lin', 0, 1}), ...
            audioPluginParameter('outGain', ...
            'Style', 'rotaryknob', ...
            'Layout', [4, 5], ...
            'DisplayName', 'Output Gain', 'DisplayNameLocation','Above', ...
            'Label', 'dB', ...
            'Mapping', {'lin', -12, 12}), ...
            audioPluginParameter('Bypass', ...
            'Style', 'vtoggle', ...
            'Layout', [6, 5], ...
            'DisplayName', 'Bypass', 'DisplayNameLocation', 'Above'));
    end

    methods
        % Constructor
        function o = TapeWorm()
            o.chorusEffect = ChorusEffect();
            o.chorusEffect.setFs(getSampleRate(o));
        end

        % Prepare To Play
        function reset(o)
            Fs = getSampleRate(o);
            o.chorusEffect.setFs(Fs);
        end

        % DSP
        function out = process(o, in)
            out = o.chorusEffect.process (in);
        end

        % Delay Parameters
        function set.delayMs(o, delayMs)
            o.delayMs = delayMs;
            o.chorusEffect.setDelayMs(delayMs);
        end

        function set.feedbackN (o, feedbackN)
            o.feedbackN = feedbackN;
            o.chorusEffect.setFeedback (feedbackN);
        end

        function set.Tri(o, Tri)
            o.Tri = Tri;
            o.chorusEffect.setTri(Tri);
        end
        
        % Mod Parameters
        function set.depthN(o, depthN)
            o.depthN = depthN;
            o.chorusEffect.setModDepth(depthN);
        end

        function set.rate(o, rate)
            o.rate = rate;
            o.chorusEffect.setModRate(rate);
        end

        function set.ModSt(o, ModSt)
            o.ModSt = ModSt;
            o.chorusEffect.setModSt(ModSt);
        end
        
        % Random Parameters
        function set.randomN(o, randomN)
            o.randomN = randomN;
            o.chorusEffect.setRandom(randomN);
        end

        function set.smoothN(o, smoothN)
            o.smoothN = smoothN;
            o.chorusEffect.setRandomSmooth(smoothN);
        end

        % Tape Parameters
        function set.inGain(o, inGain)
            o.inGain = inGain;
            linGain = 10^(inGain/20);
            o.chorusEffect.setInGain(linGain);
        end

        function set.hiss(o, hiss)
            o.hiss = hiss;
            hiss = (.02 * hiss);
            o.chorusEffect.setHiss(hiss);
        end

        function set.SatOn(o, SatOn)
            o.SatOn = SatOn;
            o.chorusEffect.setSatOn(SatOn);
        end

        function set.CompOn(o, CompOn)
            o.CompOn = CompOn;
            o.chorusEffect.setCompOn(CompOn);
        end
        
        % Plugin Parameters
        function set.mix(o, mix)
            o.mix = mix;
            o.chorusEffect.setMix(mix);
        end

        function set.outGain(o, outGain)
            o.outGain = outGain;
            linGain = 10^(outGain/20);
            o.chorusEffect.setOutGain(linGain);
        end

        function set.Bypass(o, Bypass)
            o.Bypass = Bypass;
            o.chorusEffect.setBypass(Bypass);
        end
    end
end
