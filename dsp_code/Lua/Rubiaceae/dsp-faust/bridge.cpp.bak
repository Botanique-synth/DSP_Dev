// bridge.cpp
#include "DspFaust.h"

extern "C" {
    DspFaust* dsp_new(int sr, int bs) {
        return new DspFaust(sr, bs, true);
    }
    bool dsp_start(DspFaust* d) {
        return d->start();
    }
    void dsp_stop(DspFaust* d) {
        d->stop();
    }
    void dsp_set_param(DspFaust* d, const char* address, float value) {
        d->setParamValue(address, value);
    }
    float dsp_get_param(DspFaust* d, const char* address) {
        return d->getParamValue(address);
    }
    const char* dsp_get_json_ui(DspFaust* d) {
        return d->getJSONUI();
    }
    void dsp_delete(DspFaust* d) {
        delete d;
    }
    void dsp_compute(DspFaust* d, int count, float* outL, float* outR) {
        float* outputs[2];
        outputs[0] = outL;
        outputs[1] = outR;
        d->compute(count, nullptr, outputs);
    }
}