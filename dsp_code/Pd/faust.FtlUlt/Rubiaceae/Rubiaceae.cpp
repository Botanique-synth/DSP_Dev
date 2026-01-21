/* ------------------------------------------------------------
name: "Rubiaceae"
Code generated with Faust 2.83.1 (https://faust.grame.fr)
Compilation options: -a /opt/homebrew/Cellar/faust/2.83.1/share/faust/puredata.cpp -lang cpp -i -fpga-mem-th 4 -ct 1 -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0
------------------------------------------------------------ */

#ifndef  __mydsp_H__
#define  __mydsp_H__

/************************************************************************
 ************************************************************************
 FAUST Architecture File
 Copyright (C) 2006-2011 Albert Graef <Dr.Graef@t-online.de>
 Copyright (C) 2024 Christof Ressi <christof.ressi@gmx.at>
 ---------------------------------------------------------------------
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as
 published by the Free Software Foundation; either version 2.1 of the
 License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with the GNU C Library; if not, write to the Free
 Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 02111-1307 USA.
 ************************************************************************
 ************************************************************************/

/*
 Pd architecture file, written by Albert Graef <Dr.Graef@t-online.de>
 and Christof Ressi <christof.ressi@gmx.at>.
 This was derived from minimal.cpp included in the Faust distribution.
 Please note that this is to be compiled as a shared library, which is
 then loaded dynamically by Pd as an external.
 */

#include <assert.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/************************** BEGIN misc.h *******************************
FAUST Architecture File
Copyright (C) 2003-2022 GRAME, Centre National de Creation Musicale
---------------------------------------------------------------------
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

EXCEPTION : As a special exception, you may create a larger work
that contains this FAUST architecture section and distribute
that work under terms of your choice, so long as this FAUST
architecture section is not modified.
***************************************************************************/

#ifndef __misc__
#define __misc__

#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iterator>
#include <map>
#include <string.h>
#include <string>

/************************** BEGIN meta.h *******************************
 FAUST Architecture File
 Copyright (C) 2003-2022 GRAME, Centre National de Creation Musicale
 ---------------------------------------------------------------------
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 
 EXCEPTION : As a special exception, you may create a larger work
 that contains this FAUST architecture section and distribute
 that work under terms of your choice, so long as this FAUST
 architecture section is not modified.
 ************************************************************************/

#ifndef __meta__
#define __meta__

/************************************************************************
 FAUST Architecture File
 Copyright (C) 2003-2022 GRAME, Centre National de Creation Musicale
 ---------------------------------------------------------------------
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 
 EXCEPTION : As a special exception, you may create a larger work
 that contains this FAUST architecture section and distribute
 that work under terms of your choice, so long as this FAUST
 architecture section is not modified.
 ***************************************************************************/

#ifndef __export__
#define __export__

// Version as a global string
#define FAUSTVERSION "2.83.1"

// Version as separated [major,minor,patch] values
#define FAUSTMAJORVERSION 2
#define FAUSTMINORVERSION 83
#define FAUSTPATCHVERSION 1

// Use FAUST_API for code that is part of the external API but is also compiled in faust and libfaust
// Use LIBFAUST_API for code that is compiled in faust and libfaust

#ifdef _WIN32
    #pragma warning (disable: 4251)
    #ifdef FAUST_EXE
        #define FAUST_API
        #define LIBFAUST_API
    #elif FAUST_LIB
        #define FAUST_API __declspec(dllexport)
        #define LIBFAUST_API __declspec(dllexport)
    #else
        #define FAUST_API
        #define LIBFAUST_API 
    #endif
#else
    #ifdef FAUST_EXE
        #define FAUST_API
        #define LIBFAUST_API
    #else
        #define FAUST_API __attribute__((visibility("default")))
        #define LIBFAUST_API __attribute__((visibility("default")))
    #endif
#endif

#endif

/**
 The base class of Meta handler to be used in dsp::metadata(Meta* m) method to retrieve (key, value) metadata.
 */
struct FAUST_API Meta {
    virtual ~Meta() {}
    virtual void declare(const char* key, const char* value) = 0;
};

#endif
/**************************  END  meta.h **************************/

struct MY_Meta : Meta, std::map<const char*, const char*>
{
    void declare(const char* key, const char* value) { (*this)[key] = value; }
};

static int lsr(int x, int n) { return int(((unsigned int)x) >> n); }

static int int2pow2(int x) { int r = 0; while ((1<<r) < x) r++; return r; }

static long lopt(char* argv[], const char* name, long def)
{
    for (int i = 0; argv[i]; i++) {
        if (!strcmp(argv[i], name) && argv[i + 1]) {
            return std::strtol(argv[i + 1], nullptr, 10);
        }
    }
    return def;
}

static long lopt1(int argc, char* argv[], const char* longname, const char* shortname, long def)
{
    for (int i = 2; i < argc; i++) {
        if ((strcmp(argv[i - 1], shortname) == 0 || strcmp(argv[i - 1], longname) == 0) && argv[i]) {
            return std::strtol(argv[i], nullptr, 10);
        }
    }
    return def;
}

static const char* lopts(char* argv[], const char* name, const char* def)
{
    for (int i = 0; argv[i]; i++) {
        if (!strcmp(argv[i], name) && argv[i + 1]) {
            return argv[i + 1];
        }
    }
    return def;
}

static const char* lopts1(int argc, char* argv[], const char* longname, const char* shortname, const char* def)
{
    for (int i = 2; i < argc; i++) {
        if ((strcmp(argv[i - 1], shortname) == 0 || strcmp(argv[i - 1], longname) == 0) && argv[i]) {
            return argv[i];
        }
    }
    return def;
}

static bool isopt(char* argv[], const char* name)
{
    for (int i = 0; argv[i]; i++) if (!strcmp(argv[i], name)) return true;
    return false;
}

static std::string pathToContent(const std::string& path)
{
    std::ifstream file(path.c_str(), std::ifstream::binary);
    return (!file) ? "" : std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
}

#endif

/**************************  END  misc.h **************************/
/************************** BEGIN UI.h *****************************
 FAUST Architecture File
 Copyright (C) 2003-2022 GRAME, Centre National de Creation Musicale
 ---------------------------------------------------------------------
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 
 EXCEPTION : As a special exception, you may create a larger work
 that contains this FAUST architecture section and distribute
 that work under terms of your choice, so long as this FAUST
 architecture section is not modified.
 ********************************************************************/

#ifndef __UI_H__
#define __UI_H__


#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif

/*******************************************************************************
 * UI : Faust DSP User Interface
 * User Interface as expected by the buildUserInterface() method of a DSP.
 * This abstract class contains only the method that the Faust compiler can
 * generate to describe a DSP user interface.
 ******************************************************************************/

struct Soundfile;

template <typename REAL>
struct FAUST_API UIReal {
    
    UIReal() {}
    virtual ~UIReal() {}
    
    // -- widget's layouts
    
    virtual void openTabBox(const char* label) = 0;
    virtual void openHorizontalBox(const char* label) = 0;
    virtual void openVerticalBox(const char* label) = 0;
    virtual void closeBox() = 0;
    
    // -- active widgets
    
    virtual void addButton(const char* label, REAL* zone) = 0;
    virtual void addCheckButton(const char* label, REAL* zone) = 0;
    virtual void addVerticalSlider(const char* label, REAL* zone, REAL init, REAL min, REAL max, REAL step) = 0;
    virtual void addHorizontalSlider(const char* label, REAL* zone, REAL init, REAL min, REAL max, REAL step) = 0;
    virtual void addNumEntry(const char* label, REAL* zone, REAL init, REAL min, REAL max, REAL step) = 0;
    
    // -- passive widgets
    
    virtual void addHorizontalBargraph(const char* label, REAL* zone, REAL min, REAL max) = 0;
    virtual void addVerticalBargraph(const char* label, REAL* zone, REAL min, REAL max) = 0;
    
    // -- soundfiles
    
    virtual void addSoundfile(const char* label, const char* filename, Soundfile** sf_zone) = 0;
    
    // -- metadata declarations
    
    virtual void declare(REAL* /*zone*/, const char* /*key*/, const char* /*val*/) {}

    // To be used by LLVM client
    virtual int sizeOfFAUSTFLOAT() { return sizeof(FAUSTFLOAT); }
};

struct FAUST_API UI : public UIReal<FAUSTFLOAT> {
    UI() {}
    virtual ~UI() {}
#ifdef DAISY_NO_RTTI
    virtual bool isSoundUI() const { return false; }
    virtual bool isMidiInterface() const { return false; }
#endif
};

#endif
/**************************  END  UI.h **************************/
/************************** BEGIN dsp.h ********************************
 FAUST Architecture File
 Copyright (C) 2003-2022 GRAME, Centre National de Creation Musicale
 ---------------------------------------------------------------------
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 
 EXCEPTION : As a special exception, you may create a larger work
 that contains this FAUST architecture section and distribute
 that work under terms of your choice, so long as this FAUST
 architecture section is not modified.
 ************************************************************************/

#ifndef __dsp__
#define __dsp__

#include <string>
#include <vector>
#include <cstdint>


#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif

struct FAUST_API UI;
struct FAUST_API Meta;

/**
 * DSP memory manager.
 */

struct FAUST_API dsp_memory_manager {
    
    enum MemType { kInt32, kInt32_ptr, kFloat, kFloat_ptr, kDouble, kDouble_ptr, kQuad, kQuad_ptr, kFixedPoint, kFixedPoint_ptr, kObj, kObj_ptr, kSound, kSound_ptr };

    virtual ~dsp_memory_manager() = default;
    
    /**
     * Inform the Memory Manager with the number of expected memory zones.
     * @param count - the number of expected memory zones
     */
    virtual void begin(size_t count) {}
    
    /**
     * Give the Memory Manager information on a given memory zone.
     * @param name - the memory zone name
     * @param type - the memory zone type (in MemType)
     * @param size - the size in unit of the memory type of the memory zone
     * @param size_bytes - the size in bytes of the memory zone
     * @param reads - the number of Read access to the zone used to compute one frame
     * @param writes - the number of Write access to the zone used to compute one frame
     */
    virtual void info(const char* name, MemType type, size_t size, size_t size_bytes, size_t reads, size_t writes) {}
  
    /**
     * Inform the Memory Manager that all memory zones have been described,
     * to possibly start a 'compute the best allocation strategy' step.
     */
    virtual void end() {}
    
    /**
     * Allocate a memory zone.
     * @param size - the memory zone size in bytes
     */
    virtual void* allocate(size_t size) = 0;
    
    /**
     * Destroy a memory zone.
     * @param ptr - the memory zone pointer to be deallocated
     */
    virtual void destroy(void* ptr) = 0;
    
};

/**
* Signal processor definition.
*/

class FAUST_API dsp {

    public:

        dsp() = default;
        virtual ~dsp() = default;

        /* Return instance number of audio inputs */
        virtual int getNumInputs() = 0;
    
        /* Return instance number of audio outputs */
        virtual int getNumOutputs() = 0;
    
        /**
         * Trigger the ui_interface parameter with instance specific calls
         * to 'openTabBox', 'addButton', 'addVerticalSlider'... in order to build the UI.
         *
         * @param ui_interface - the user interface builder
         */
        virtual void buildUserInterface(UI* ui_interface) = 0;
    
        /* Return the sample rate currently used by the instance */
        virtual int getSampleRate() = 0;
    
        /**
         * Global init, calls the following methods:
         * - static class 'classInit': static tables initialization
         * - 'instanceInit': constants and instance state initialization
         *
         * @param sample_rate - the sampling rate in Hz
         */
        virtual void init(int sample_rate) = 0;

        /**
         * Init instance state.
         *
         * @param sample_rate - the sampling rate in Hz
         */
        virtual void instanceInit(int sample_rate) = 0;
    
        /**
         * Init instance constant state.
         *
         * @param sample_rate - the sampling rate in Hz
         */
        virtual void instanceConstants(int sample_rate) = 0;
    
        /* Init default control parameters values */
        virtual void instanceResetUserInterface() = 0;
    
        /* Init instance state (like delay lines...) but keep the control parameter values */
        virtual void instanceClear() = 0;
 
        /**
         * Return a clone of the instance.
         *
         * @return a copy of the instance on success, otherwise a null pointer.
         */
        virtual ::dsp* clone() = 0;
    
        /**
         * Trigger the Meta* m parameter with instance specific calls to 'declare' (key, value) metadata.
         *
         * @param m - the Meta* meta user
         */
        virtual void metadata(Meta* m) = 0;
    
        /**
         * Read all controllers (buttons, sliders, etc.), and update the DSP state to be used by 'frame' or 'compute'.
         * This method will be filled with the -ec (--external-control) option.
         */
        virtual void control() {}
    
        /**
         * DSP instance computation to process one single frame.
         *
         * Note that by default inputs and outputs buffers are supposed to be distinct memory zones,
         * so one cannot safely write frame(inputs, inputs).
         * The -inpl option can be used for that, but only in scalar mode for now.
         * This method will be filled with the -os (--one-sample) option.
         *
         * @param inputs - the input audio buffers as an array of FAUSTFLOAT samples (eiher float, double or quad)
         * @param outputs - the output audio buffers as an array of FAUSTFLOAT samples (eiher float, double or quad)
         */
        virtual void frame(FAUSTFLOAT* inputs, FAUSTFLOAT* outputs) {}
        
        /**
         * DSP instance computation to be called with successive in/out audio buffers.
         *
         * Note that by default inputs and outputs buffers are supposed to be distinct memory zones,
         * so one cannot safely write compute(count, inputs, inputs).
         * The -inpl compilation option can be used for that, but only in scalar mode for now.
         *
         * @param count - the number of frames to compute
         * @param inputs - the input audio buffers as an array of non-interleaved FAUSTFLOAT buffers
         * (containing either float, double or quad samples)
         * @param outputs - the output audio buffers as an array of non-interleaved FAUSTFLOAT buffers
         * (containing either float, double or quad samples)
         */
        virtual void compute(int count, FAUSTFLOAT** inputs, FAUSTFLOAT** outputs) = 0;
    
        /**
         * Alternative DSP instance computation method for use by subclasses, incorporating an additional `date_usec` parameter,
         * which specifies the timestamp of the first sample in the audio buffers.
         *
         * @param date_usec - the timestamp in microsec given by audio driver. By convention timestamp of -1 means 'no timestamp conversion',
         * events already have a timestamp expressed in frames.
         * @param count - the number of frames to compute
         * @param inputs - the input audio buffers as an array of non-interleaved FAUSTFLOAT samples (either float, double or quad)
         * @param outputs - the output audio buffers as an array of non-interleaved FAUSTFLOAT samples (either float, double or quad)
         */
        virtual void compute(double /*date_usec*/, int count, FAUSTFLOAT** inputs, FAUSTFLOAT** outputs) { compute(count, inputs, outputs); }
       
};

/**
 * Generic DSP decorator.
 */

class FAUST_API decorator_dsp : public ::dsp {

    protected:

        ::dsp* fDSP;

    public:

        decorator_dsp(::dsp* dsp = nullptr):fDSP(dsp) {}
        virtual ~decorator_dsp() { delete fDSP; }

        virtual int getNumInputs() override { return fDSP->getNumInputs(); }
        virtual int getNumOutputs() override { return fDSP->getNumOutputs(); }
        virtual void buildUserInterface(UI* ui_interface) override { fDSP->buildUserInterface(ui_interface); }
        virtual int getSampleRate() override { return fDSP->getSampleRate(); }
        virtual void init(int sample_rate) override { fDSP->init(sample_rate); }
        virtual void instanceInit(int sample_rate) override { fDSP->instanceInit(sample_rate); }
        virtual void instanceConstants(int sample_rate) override { fDSP->instanceConstants(sample_rate); }
        virtual void instanceResetUserInterface() override { fDSP->instanceResetUserInterface(); }
        virtual void instanceClear() override { fDSP->instanceClear(); }
        virtual decorator_dsp* clone() override { return new decorator_dsp(fDSP->clone()); }
        virtual void metadata(Meta* m) override { fDSP->metadata(m); }
        // Beware: subclasses usually have to overload the two 'compute' methods
        virtual void control() override { fDSP->control(); }
        virtual void frame(FAUSTFLOAT* inputs, FAUSTFLOAT* outputs) override { fDSP->frame(inputs, outputs); }
        virtual void compute(int count, FAUSTFLOAT** inputs, FAUSTFLOAT** outputs) override { fDSP->compute(count, inputs, outputs); }
        virtual void compute(double date_usec, int count, FAUSTFLOAT** inputs, FAUSTFLOAT** outputs) override { fDSP->compute(date_usec, count, inputs, outputs); }
    
};

/**
 * DSP factory class, used with LLVM and Interpreter backends
 * to create DSP instances from a compiled DSP program.
 */

class FAUST_API dsp_factory {
    
    protected:
    
        // So that to force sub-classes to use deleteDSPFactory(dsp_factory* factory);
        virtual ~dsp_factory() = default;
    
    public:
    
        /* Return factory name */
        virtual std::string getName() = 0;
    
        /* Return factory SHA key */
        virtual std::string getSHAKey() = 0;
    
        /* Return factory expanded DSP code */
        virtual std::string getDSPCode() = 0;
    
        /* Return factory compile options */
        virtual std::string getCompileOptions() = 0;
    
        /* Get the Faust DSP factory list of library dependancies */
        virtual std::vector<std::string> getLibraryList() = 0;
    
        /* Get the list of all used includes */
        virtual std::vector<std::string> getIncludePathnames() = 0;
    
        /* Get warning messages list for a given compilation */
        virtual std::vector<std::string> getWarningMessages() = 0;
    
        /* Create a new DSP instance, to be deleted with C++ 'delete' */
        virtual ::dsp* createDSPInstance() = 0;
    
        /* Static tables initialization, possibly implemened in sub-classes*/
        virtual void classInit(int sample_rate) {};
    
        /* Set a custom memory manager to be used when creating instances */
        virtual void setMemoryManager(dsp_memory_manager* manager) = 0;
    
        /* Return the currently set custom memory manager */
        virtual dsp_memory_manager* getMemoryManager() = 0;
    
};

// Denormal handling

#if defined (__SSE__)
#include <xmmintrin.h>
#endif

class FAUST_API ScopedNoDenormals {
    
    private:
    
        intptr_t fpsr = 0;
        
        void setFpStatusRegister(intptr_t fpsr_aux) noexcept
        {
        #if defined (__arm64__) || defined (__aarch64__)
            asm volatile("msr fpcr, %0" : : "ri" (fpsr_aux));
        #elif defined (__SSE__)
            // The volatile keyword here is needed to workaround a bug in AppleClang 13.0
            // which aggressively optimises away the variable otherwise
            volatile uint32_t fpsr_w = static_cast<uint32_t>(fpsr_aux);
            _mm_setcsr(fpsr_w);
        #endif
        }
        
        void getFpStatusRegister() noexcept
        {
        #if defined (__arm64__) || defined (__aarch64__)
            asm volatile("mrs %0, fpcr" : "=r" (fpsr));
        #elif defined (__SSE__)
            fpsr = static_cast<intptr_t>(_mm_getcsr());
        #endif
        }
    
    public:
    
        ScopedNoDenormals() noexcept
        {
        #if defined (__arm64__) || defined (__aarch64__)
            intptr_t mask = (1 << 24 /* FZ */);
        #elif defined (__SSE__)
        #if defined (__SSE2__)
            intptr_t mask = 0x8040;
        #else
            intptr_t mask = 0x8000;
        #endif
        #else
            intptr_t mask = 0x0000;
        #endif
            getFpStatusRegister();
            setFpStatusRegister(fpsr | mask);
        }
        
        ~ScopedNoDenormals() noexcept
        {
            setFpStatusRegister(fpsr);
        }

};

#define AVOIDDENORMALS ScopedNoDenormals ftz_scope;

#endif

/************************** END dsp.h **************************/

/******************************************************************************
 *******************************************************************************
 
 VECTOR INTRINSICS
 
 *******************************************************************************
 *******************************************************************************/


/***************************************************************************
 Pd UI interface
 ***************************************************************************/

enum ui_elem_type_t {
    UI_BUTTON, UI_CHECK_BUTTON,
    UI_V_SLIDER, UI_H_SLIDER, UI_NUM_ENTRY,
    UI_V_BARGRAPH, UI_H_BARGRAPH,
    UI_END_GROUP, UI_V_GROUP, UI_H_GROUP, UI_T_GROUP
};

struct ui_elem_t {
    ui_elem_type_t type;
    char *label;
    float *zone;
    float init, min, max, step;
};

class PdUI : public UI
{
public:
    const char *name;
    int nelems, level;
    ui_elem_t *elems;
    
    PdUI();
    PdUI(const char *nm, const char *s);
    virtual ~PdUI();
    
protected:
    std::string path;
    void add_elem(ui_elem_type_t type, const char *label = NULL);
    void add_elem(ui_elem_type_t type, const char *label, float *zone);
    void add_elem(ui_elem_type_t type, const char *label, float *zone,
                  float init, float min, float max, float step);
    void add_elem(ui_elem_type_t type, const char *label, float *zone,
                  float min, float max);
    
public:
    virtual void addButton(const char* label, float* zone);
    virtual void addCheckButton(const char* label, float* zone);
    virtual void addVerticalSlider(const char* label, float* zone, float init, float min, float max, float step);
    virtual void addHorizontalSlider(const char* label, float* zone, float init, float min, float max, float step);
    virtual void addNumEntry(const char* label, float* zone, float init, float min, float max, float step);
    
    virtual void addHorizontalBargraph(const char* label, float* zone, float min, float max);
    virtual void addVerticalBargraph(const char* label, float* zone, float min, float max);
    
    virtual void addSoundfile(const char* label, const char* filename, Soundfile** sf_zone) {}
    
    virtual void openTabBox(const char* label);
    virtual void openHorizontalBox(const char* label);
    virtual void openVerticalBox(const char* label);
    virtual void closeBox();
    
    virtual void run();
};

static std::string mangle(const char *name, int level, const char *s)
{
    const char *s0 = s;
    std::string t = "";
    if (!s) return t;
    // Get rid of bogus "0x00" labels in recent Faust revisions. Also, for
    // backward compatibility with old Faust versions, make sure that default
    // toplevel groups and explicit toplevel groups with an empty label are
    // treated alike (these both return "0x00" labels in the latest Faust, but
    // would be treated inconsistently in earlier versions).
    if (!*s || strcmp(s, "0x00") == 0) {
        if (level == 0)
            // toplevel group with empty label, map to dsp name
            s = name;
        else
            // empty label
            s = "";
    }
    while (*s)
        if (isalnum(*s))
            t += *(s++);
        else {
            const char *s1 = s;
            while (*s && !isalnum(*s)) ++s;
            if (s1 != s0 && *s) t += "-";
        }
    return t;
}

static std::string normpath(std::string path)
{
    path = std::string("/")+path;
    int pos = path.find("//");
    while (pos >= 0) {
        path.erase(pos, 1);
        pos = path.find("//");
    }
    size_t len = path.length();
    if (len > 1 && path[len-1] == '/')
        path.erase(len-1, 1);
    return path;
}

static std::string pathcat(std::string path, std::string label)
{
    if (path.empty())
        return normpath(label);
    else if (label.empty())
        return normpath(path);
    else
        return normpath(path+"/"+label);
}

PdUI::PdUI()
{
    nelems = level = 0;
    elems = NULL;
    name = "";
    path = "";
}

PdUI::PdUI(const char *nm, const char *s)
{
    nelems = level = 0;
    elems = NULL;
    name = nm?nm:"";
    path = s?s:"";
}

PdUI::~PdUI()
{
    if (elems) {
        for (int i = 0; i < nelems; i++)
            if (elems[i].label)
                free(elems[i].label);
        free(elems);
    }
}

inline void PdUI::add_elem(ui_elem_type_t type, const char *label)
{
    ui_elem_t *elems1 = (ui_elem_t*)realloc(elems, (nelems+1)*sizeof(ui_elem_t));
    if (elems1)
        elems = elems1;
    else
        return;
    std::string s = pathcat(path, mangle(name, level, label));
    elems[nelems].type = type;
    elems[nelems].label = strdup(s.c_str());
    elems[nelems].zone = NULL;
    elems[nelems].init = 0.0;
    elems[nelems].min = 0.0;
    elems[nelems].max = 0.0;
    elems[nelems].step = 0.0;
    nelems++;
}

inline void PdUI::add_elem(ui_elem_type_t type, const char *label, float *zone)
{
    ui_elem_t *elems1 = (ui_elem_t*)realloc(elems, (nelems+1)*sizeof(ui_elem_t));
    if (elems1)
        elems = elems1;
    else
        return;
    std::string s = pathcat(path, mangle(name, level, label));
    elems[nelems].type = type;
    elems[nelems].label = strdup(s.c_str());
    elems[nelems].zone = zone;
    elems[nelems].init = 0.0;
    elems[nelems].min = 0.0;
    elems[nelems].max = 1.0;
    elems[nelems].step = 1.0;
    nelems++;
}

inline void PdUI::add_elem(ui_elem_type_t type, const char *label, float *zone,
                           float init, float min, float max, float step)
{
    ui_elem_t *elems1 = (ui_elem_t*)realloc(elems, (nelems+1)*sizeof(ui_elem_t));
    if (elems1)
        elems = elems1;
    else
        return;
    std::string s = pathcat(path, mangle(name, level, label));
    elems[nelems].type = type;
    elems[nelems].label = strdup(s.c_str());
    elems[nelems].zone = zone;
    elems[nelems].init = init;
    elems[nelems].min = min;
    elems[nelems].max = max;
    elems[nelems].step = step;
    nelems++;
}

inline void PdUI::add_elem(ui_elem_type_t type, const char *label, float *zone,
                           float min, float max)
{
    ui_elem_t *elems1 = (ui_elem_t*)realloc(elems, (nelems+1)*sizeof(ui_elem_t));
    if (elems1)
        elems = elems1;
    else
        return;
    std::string s = pathcat(path, mangle(name, level, label));
    elems[nelems].type = type;
    elems[nelems].label = strdup(s.c_str());
    elems[nelems].zone = zone;
    elems[nelems].init = 0.0;
    elems[nelems].min = min;
    elems[nelems].max = max;
    elems[nelems].step = 0.0;
    nelems++;
}

void PdUI::addButton(const char* label, float* zone)
{ add_elem(UI_BUTTON, label, zone); }
void PdUI::addCheckButton(const char* label, float* zone)
{ add_elem(UI_CHECK_BUTTON, label, zone); }
void PdUI::addVerticalSlider(const char* label, float* zone, float init, float min, float max, float step)
{ add_elem(UI_V_SLIDER, label, zone, init, min, max, step); }
void PdUI::addHorizontalSlider(const char* label, float* zone, float init, float min, float max, float step)
{ add_elem(UI_H_SLIDER, label, zone, init, min, max, step); }
void PdUI::addNumEntry(const char* label, float* zone, float init, float min, float max, float step)
{ add_elem(UI_NUM_ENTRY, label, zone, init, min, max, step); }

void PdUI::addHorizontalBargraph(const char* label, float* zone, float min, float max)
{ add_elem(UI_H_BARGRAPH, label, zone, min, max); }
void PdUI::addVerticalBargraph(const char* label, float* zone, float min, float max)
{ add_elem(UI_V_BARGRAPH, label, zone, min, max); }

void PdUI::openTabBox(const char* label)
{
    if (!path.empty()) path += "/";
    path += mangle(name, level, label);
    level++;
}
void PdUI::openHorizontalBox(const char* label)
{
    if (!path.empty()) path += "/";
    path += mangle(name, level, label);
    level++;
}
void PdUI::openVerticalBox(const char* label)
{
    if (!path.empty()) path += "/";
    path += mangle(name, level, label);
    level++;
}
void PdUI::closeBox()
{
    int pos = path.rfind("/");
    if (pos < 0) pos = 0;
    path.erase(pos);
    level--;
}

void PdUI::run() {}

/******************************************************************************
 *******************************************************************************
 
 FAUST DSP
 
 *******************************************************************************
 *******************************************************************************/

//----------------------------------------------------------------------------
//  FAUST generated signal processor
//----------------------------------------------------------------------------

#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif 

/* link with : "" */
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <math.h>

#ifndef FAUSTCLASS 
#define FAUSTCLASS mydsp
#endif

#ifdef __APPLE__ 
#define exp10f __exp10f
#define exp10 __exp10
#endif

#if defined(_WIN32)
#define RESTRICT __restrict
#else
#define RESTRICT __restrict__
#endif

class mydspSIG0 {
	
  private:
	
	
  public:
	
	int getNumInputsmydspSIG0() {
		return 0;
	}
	int getNumOutputsmydspSIG0() {
		return 1;
	}
	
	void instanceInitmydspSIG0(int sample_rate) {
	}
	
	void fillmydspSIG0(int count, float* table) {
		for (int i1 = 0; i1 < count; i1 = i1 + 1) {
			table[i1] = 0.2f;
		}
	}

};

static mydspSIG0* newmydspSIG0() { return (mydspSIG0*)new mydspSIG0(); }
static void deletemydspSIG0(mydspSIG0* dsp) { delete dsp; }

class mydspSIG1 {
	
  private:
	
	
  public:
	
	int getNumInputsmydspSIG1() {
		return 0;
	}
	int getNumOutputsmydspSIG1() {
		return 1;
	}
	
	void instanceInitmydspSIG1(int sample_rate) {
	}
	
	void fillmydspSIG1(int count, int* table) {
		for (int i2 = 0; i2 < count; i2 = i2 + 1) {
			table[i2] = 4;
		}
	}

};

static mydspSIG1* newmydspSIG1() { return (mydspSIG1*)new mydspSIG1(); }
static void deletemydspSIG1(mydspSIG1* dsp) { delete dsp; }

class mydspSIG2 {
	
  private:
	
	
  public:
	
	int getNumInputsmydspSIG2() {
		return 0;
	}
	int getNumOutputsmydspSIG2() {
		return 1;
	}
	
	void instanceInitmydspSIG2(int sample_rate) {
	}
	
	void fillmydspSIG2(int count, int* table) {
		for (int i3 = 0; i3 < count; i3 = i3 + 1) {
			table[i3] = 0;
		}
	}

};

static mydspSIG2* newmydspSIG2() { return (mydspSIG2*)new mydspSIG2(); }
static void deletemydspSIG2(mydspSIG2* dsp) { delete dsp; }

static float mydsp_faustpower2_f(float value) {
	return value * value;
}
static float mydsp_faustpower4_f(float value) {
	return value * value * value * value;
}
static float mydsp_faustpower6_f(float value) {
	return value * value * value * value * value * value;
}
static float mydsp_faustpower8_f(float value) {
	return value * value * value * value * value * value * value * value;
}
static float mydsp_faustpower3_f(float value) {
	return value * value * value;
}
static float mydsp_faustpower5_f(float value) {
	return value * value * value * value * value;
}
static float mydsp_faustpower7_f(float value) {
	return value * value * value * value * value * value * value;
}

class mydsp : public dsp {
	
 private:
	
	FAUSTFLOAT fVslider0;
	int fSampleRate;
	float fConst0;
	float fConst1;
	float fConst2;
	float fConst3;
	float fConst4;
	float fConst5;
	float fConst6;
	float fConst7;
	float fConst8;
	float fConst9;
	FAUSTFLOAT fHslider0;
	int IOTA0;
	float fConst10;
	FAUSTFLOAT fHslider1;
	int iVec0[2];
	float fRec36[2];
	float fConst11;
	float fConst12;
	float fRec35[3];
	float fConst13;
	float fRec34[3];
	float fVec1[512];
	int iRec38[2];
	int iRec39[2];
	float fRec37[2];
	FAUSTFLOAT fHslider2;
	float fRec33[3];
	float fRec32[3];
	float fConst14;
	float fRec31[3];
	float fRec30[3];
	float fRec29[3];
	float fRec28[3];
	float fRec27[3];
	float fRec26[3];
	float fRec25[3];
	float fRec24[3];
	float fRec23[3];
	float fRec22[3];
	float fRec21[3];
	float fRec20[3];
	float fRec19[3];
	float fRec18[3];
	float fRec17[3];
	float fRec16[3];
	float fRec15[3];
	float fRec14[3];
	float fRec13[3];
	float fRec12[3];
	float fRec11[3];
	float fRec10[3];
	float fRec9[3];
	float fRec8[3];
	float fRec7[3];
	float fRec6[3];
	float fRec5[3];
	float fRec4[3];
	float fRec3[3];
	float fRec2[3];
	float fVec2[2];
	float fConst15;
	float fConst16;
	float fConst17;
	float fRec1[3];
	float ftbl0[17];
	float fConst18;
	FAUSTFLOAT fVslider1;
	int iRec40[2];
	int iVec3[2];
	FAUSTFLOAT fVslider2;
	float fVec4[2];
	float fRec41[2];
	int iRec42[2];
	int itbl1[17];
	FAUSTFLOAT fVslider3;
	float fVec5[2];
	float fRec43[2];
	int iRec46[2];
	FAUSTFLOAT fCheckbox0;
	float fConst19;
	FAUSTFLOAT fVslider4;
	float fRec51[2];
	float fVec6[2];
	float fRec50[2];
	int iVec7[2];
	FAUSTFLOAT fVslider5;
	int iRec52[2];
	int iVec8[33554432];
	float fConst20;
	float fConst21;
	FAUSTFLOAT fVslider6;
	float fConst22;
	float fRec53[2];
	int iVec9[2];
	int iRec49[2];
	int iVec10[2];
	float fRec47[2];
	float fRec48[2];
	float fConst23;
	FAUSTFLOAT fVslider7;
	float fRec54[2];
	int iRec56[2];
	FAUSTFLOAT fVslider8;
	int iRec57[2];
	int iRec55[2];
	int itbl2[17];
	FAUSTFLOAT fVslider9;
	float fRec59[2];
	float fRec58[2];
	float ftbl3[17];
	FAUSTFLOAT fVslider10;
	float fRec61[2];
	float fRec60[2];
	float fRec45[3];
	float fRec44[3];
	float fRec62[3];
	float fRec64[3];
	float fRec63[3];
	float fRec65[3];
	float fRec67[3];
	float fRec66[3];
	float fRec68[3];
	float fRec70[3];
	float fRec69[3];
	float fRec71[3];
	float fRec73[3];
	float fRec72[3];
	float fRec74[3];
	float fRec76[3];
	float fRec75[3];
	float fRec77[3];
	float fRec79[3];
	float fRec78[3];
	float fRec80[3];
	float fRec82[3];
	float fRec81[3];
	float fRec83[3];
	float fRec85[3];
	float fRec84[3];
	float fRec86[3];
	float fRec88[3];
	float fRec87[3];
	float fRec89[3];
	float fRec91[3];
	float fRec90[3];
	float fRec92[3];
	float fRec94[3];
	float fRec93[3];
	float fRec95[3];
	float fRec97[3];
	float fRec96[3];
	float fRec98[3];
	float fRec100[3];
	float fRec99[3];
	float fRec101[3];
	float fRec103[3];
	float fRec102[3];
	float fRec104[3];
	float fRec106[3];
	float fRec105[3];
	float fRec107[3];
	float fRec109[3];
	float fRec108[3];
	float fRec110[3];
	float fRec112[3];
	float fRec111[3];
	float fRec113[3];
	float fRec115[3];
	float fRec114[3];
	float fRec116[3];
	float fRec118[3];
	float fRec117[3];
	float fRec119[3];
	float fRec121[3];
	float fRec120[3];
	float fRec122[3];
	float fRec124[3];
	float fRec123[3];
	float fRec125[3];
	float fRec127[3];
	float fRec126[3];
	float fRec128[3];
	float fRec130[3];
	float fRec129[3];
	float fRec131[3];
	float fRec133[3];
	float fRec132[3];
	float fRec134[3];
	float fRec136[3];
	float fRec135[3];
	float fRec137[3];
	float fRec139[3];
	float fRec138[3];
	float fRec140[3];
	float fRec142[3];
	float fRec141[3];
	float fRec143[3];
	float fRec145[3];
	float fRec144[3];
	float fRec146[3];
	float fRec148[3];
	float fRec147[3];
	float fRec149[3];
	float fRec151[3];
	float fRec150[3];
	float fRec152[3];
	float fRec154[3];
	float fRec153[3];
	float fRec155[3];
	float fRec0[4194304];
	float fConst24;
	float fRec192[2];
	float fRec191[3];
	float fRec190[3];
	float fVec11[512];
	float fRec189[3];
	float fRec188[3];
	float fRec187[3];
	float fRec186[3];
	float fRec185[3];
	float fRec184[3];
	float fRec183[3];
	float fRec182[3];
	float fRec181[3];
	float fRec180[3];
	float fRec179[3];
	float fRec178[3];
	float fRec177[3];
	float fRec176[3];
	float fRec175[3];
	float fRec174[3];
	float fRec173[3];
	float fRec172[3];
	float fRec171[3];
	float fRec170[3];
	float fRec169[3];
	float fRec168[3];
	float fRec167[3];
	float fRec166[3];
	float fRec165[3];
	float fRec164[3];
	float fRec163[3];
	float fRec162[3];
	float fRec161[3];
	float fRec160[3];
	float fRec159[3];
	float fRec158[3];
	float fVec12[2];
	float fRec157[3];
	float fRec156[4194304];
	
 public:
	mydsp() {
	}
	
	mydsp(const mydsp&) = default;
	
	virtual ~mydsp() = default;
	
	mydsp& operator=(const mydsp&) = default;
	
	void metadata(Meta* m) { 
		m->declare("aanl.lib/ADAA1:author", "Dario Sanfilippo");
		m->declare("aanl.lib/ADAA1:copyright", "Copyright (C) 2021 Dario Sanfilippo     <sanfilippo.dario@gmail.com>");
		m->declare("aanl.lib/ADAA1:license", "MIT License");
		m->declare("aanl.lib/name", "Faust Antialiased Nonlinearities");
		m->declare("aanl.lib/tanh1:author", "Dario Sanfilippo");
		m->declare("aanl.lib/tanh1:copyright", "Copyright (C) 2021 Dario Sanfilippo     <sanfilippo.dario@gmail.com>");
		m->declare("aanl.lib/tanh1:license", "MIT License");
		m->declare("aanl.lib/version", "1.4.2");
		m->declare("basics.lib/counter:author", "Stephane Letz");
		m->declare("basics.lib/name", "Faust Basic Element Library");
		m->declare("basics.lib/sAndH:author", "Romain Michon");
		m->declare("basics.lib/version", "1.22.0");
		m->declare("compile_options", "-a /opt/homebrew/Cellar/faust/2.83.1/share/faust/puredata.cpp -lang cpp -i -fpga-mem-th 4 -ct 1 -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0");
		m->declare("delays.lib/name", "Faust Delay Library");
		m->declare("delays.lib/version", "1.2.0");
		m->declare("filename", "Rubiaceae.dsp");
		m->declare("filters.lib/fir:author", "Julius O. Smith III");
		m->declare("filters.lib/fir:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/fir:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/highpass:author", "Julius O. Smith III");
		m->declare("filters.lib/highpass:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/iir:author", "Julius O. Smith III");
		m->declare("filters.lib/iir:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/iir:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/lowpass0_highpass1", "MIT-style STK-4.3 license");
		m->declare("filters.lib/lowpass0_highpass1:author", "Julius O. Smith III");
		m->declare("filters.lib/lowpass:author", "Julius O. Smith III");
		m->declare("filters.lib/lowpass:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/lowpass:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/name", "Faust Filters Library");
		m->declare("filters.lib/resonbp:author", "Julius O. Smith III");
		m->declare("filters.lib/resonbp:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/resonbp:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/resonhp:author", "Julius O. Smith III");
		m->declare("filters.lib/resonhp:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/resonhp:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/resonlp:author", "Julius O. Smith III");
		m->declare("filters.lib/resonlp:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/resonlp:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/tf2:author", "Julius O. Smith III");
		m->declare("filters.lib/tf2:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/tf2:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/tf2s:author", "Julius O. Smith III");
		m->declare("filters.lib/tf2s:copyright", "Copyright (C) 2003-2019 by Julius O. Smith III <jos@ccrma.stanford.edu>");
		m->declare("filters.lib/tf2s:license", "MIT-style STK-4.3 license");
		m->declare("filters.lib/version", "1.7.1");
		m->declare("maths.lib/author", "GRAME");
		m->declare("maths.lib/copyright", "GRAME");
		m->declare("maths.lib/license", "LGPL with exception");
		m->declare("maths.lib/name", "Faust Math Library");
		m->declare("maths.lib/version", "2.9.0");
		m->declare("misceffects.lib/dryWetMixer:author", "David Braun, revised by Stéphane Letz");
		m->declare("misceffects.lib/name", "Misc Effects Library");
		m->declare("misceffects.lib/version", "2.5.1");
		m->declare("name", "Rubiaceae");
		m->declare("noises.lib/name", "Faust Noise Generator Library");
		m->declare("noises.lib/version", "1.5.0");
		m->declare("oscillators.lib/hs_phasor:author", "Mike Olsen, revised by Stéphane Letz");
		m->declare("oscillators.lib/name", "Faust Oscillator Library");
		m->declare("oscillators.lib/version", "1.6.0");
		m->declare("platform.lib/name", "Generic Platform Library");
		m->declare("platform.lib/version", "1.3.0");
		m->declare("quantizers.lib/name", "Faust Frequency Quantization Library");
		m->declare("quantizers.lib/version", "1.1.2");
		m->declare("signals.lib/name", "Faust Signal Routing Library");
		m->declare("signals.lib/version", "1.6.0");
		m->declare("webaudio.lib/author", "GRAME");
		m->declare("webaudio.lib/copyright", "GRAME");
		m->declare("webaudio.lib/license", "LGPL with exception");
		m->declare("webaudio.lib/name", "Faust WebAudio Filters Library");
		m->declare("webaudio.lib/version", "1.1.0");
	}

	virtual int getNumInputs() {
		return 0;
	}
	virtual int getNumOutputs() {
		return 2;
	}
	
	static void classInit(int sample_rate) {
	}
	
	virtual void instanceConstants(int sample_rate) {
		fSampleRate = sample_rate;
		fConst0 = std::min<float>(1.92e+05f, std::max<float>(1.0f, static_cast<float>(fSampleRate)));
		fConst1 = std::tan(314.15927f / fConst0);
		fConst2 = mydsp_faustpower2_f(fConst1);
		fConst3 = 1.0f / fConst1;
		fConst4 = (fConst3 + 1.4142135f) / fConst1 + 1.0f;
		fConst5 = 1.0f / (fConst2 * fConst4);
		fConst6 = std::tan(31415.926f / fConst0);
		fConst7 = 1.0f / fConst6;
		fConst8 = 1.0f / ((fConst7 + 0.76536685f) / fConst6 + 1.0f);
		fConst9 = 1.0f / ((fConst7 + 1.847759f) / fConst6 + 1.0f);
		fConst10 = 15.0f * fConst0;
		fConst11 = (fConst7 + -1.847759f) / fConst6 + 1.0f;
		fConst12 = 2.0f * (1.0f - 1.0f / mydsp_faustpower2_f(fConst6));
		fConst13 = (fConst7 + -0.76536685f) / fConst6 + 1.0f;
		fConst14 = 2.0f / fConst0;
		fConst15 = 1.0f / fConst4;
		fConst16 = (fConst3 + -1.4142135f) / fConst1 + 1.0f;
		fConst17 = 2.0f * (1.0f - 1.0f / fConst2);
		mydspSIG0* sig0 = newmydspSIG0();
		sig0->instanceInitmydspSIG0(sample_rate);
		sig0->fillmydspSIG0(17, ftbl0);
		fConst18 = 6e+01f * fConst0;
		mydspSIG1* sig1 = newmydspSIG1();
		sig1->instanceInitmydspSIG1(sample_rate);
		sig1->fillmydspSIG1(17, itbl1);
		fConst19 = 0.016666668f / fConst0;
		fConst20 = 0.5f * fConst0;
		fConst21 = 44.1f / fConst0;
		fConst22 = 1.0f - fConst21;
		fConst23 = 3.1415927f / fConst0;
		mydspSIG2* sig2 = newmydspSIG2();
		sig2->instanceInitmydspSIG2(sample_rate);
		sig2->fillmydspSIG2(17, itbl2);
		sig0->instanceInitmydspSIG0(sample_rate);
		sig0->fillmydspSIG0(17, ftbl3);
		fConst24 = 0.15f * fConst0;
		deletemydspSIG0(sig0);
		deletemydspSIG1(sig1);
		deletemydspSIG2(sig2);
	}
	
	virtual void instanceResetUserInterface() {
		fVslider0 = static_cast<FAUSTFLOAT>(0.5f);
		fHslider0 = static_cast<FAUSTFLOAT>(0.75f);
		fHslider1 = static_cast<FAUSTFLOAT>(5e+02f);
		fHslider2 = static_cast<FAUSTFLOAT>(0.5f);
		fVslider1 = static_cast<FAUSTFLOAT>(8e+01f);
		fVslider2 = static_cast<FAUSTFLOAT>(0.5f);
		fVslider3 = static_cast<FAUSTFLOAT>(4.0f);
		fCheckbox0 = static_cast<FAUSTFLOAT>(0.0f);
		fVslider4 = static_cast<FAUSTFLOAT>(8e+01f);
		fVslider5 = static_cast<FAUSTFLOAT>(0.5f);
		fVslider6 = static_cast<FAUSTFLOAT>(0.25f);
		fVslider7 = static_cast<FAUSTFLOAT>(1e+02f);
		fVslider8 = static_cast<FAUSTFLOAT>(0.9f);
		fVslider9 = static_cast<FAUSTFLOAT>(0.0f);
		fVslider10 = static_cast<FAUSTFLOAT>(0.2f);
	}
	
	virtual void instanceClear() {
		IOTA0 = 0;
		for (int l0 = 0; l0 < 2; l0 = l0 + 1) {
			iVec0[l0] = 0;
		}
		for (int l1 = 0; l1 < 2; l1 = l1 + 1) {
			fRec36[l1] = 0.0f;
		}
		for (int l2 = 0; l2 < 3; l2 = l2 + 1) {
			fRec35[l2] = 0.0f;
		}
		for (int l3 = 0; l3 < 3; l3 = l3 + 1) {
			fRec34[l3] = 0.0f;
		}
		for (int l4 = 0; l4 < 512; l4 = l4 + 1) {
			fVec1[l4] = 0.0f;
		}
		for (int l5 = 0; l5 < 2; l5 = l5 + 1) {
			iRec38[l5] = 0;
		}
		for (int l6 = 0; l6 < 2; l6 = l6 + 1) {
			iRec39[l6] = 0;
		}
		for (int l7 = 0; l7 < 2; l7 = l7 + 1) {
			fRec37[l7] = 0.0f;
		}
		for (int l8 = 0; l8 < 3; l8 = l8 + 1) {
			fRec33[l8] = 0.0f;
		}
		for (int l9 = 0; l9 < 3; l9 = l9 + 1) {
			fRec32[l9] = 0.0f;
		}
		for (int l10 = 0; l10 < 3; l10 = l10 + 1) {
			fRec31[l10] = 0.0f;
		}
		for (int l11 = 0; l11 < 3; l11 = l11 + 1) {
			fRec30[l11] = 0.0f;
		}
		for (int l12 = 0; l12 < 3; l12 = l12 + 1) {
			fRec29[l12] = 0.0f;
		}
		for (int l13 = 0; l13 < 3; l13 = l13 + 1) {
			fRec28[l13] = 0.0f;
		}
		for (int l14 = 0; l14 < 3; l14 = l14 + 1) {
			fRec27[l14] = 0.0f;
		}
		for (int l15 = 0; l15 < 3; l15 = l15 + 1) {
			fRec26[l15] = 0.0f;
		}
		for (int l16 = 0; l16 < 3; l16 = l16 + 1) {
			fRec25[l16] = 0.0f;
		}
		for (int l17 = 0; l17 < 3; l17 = l17 + 1) {
			fRec24[l17] = 0.0f;
		}
		for (int l18 = 0; l18 < 3; l18 = l18 + 1) {
			fRec23[l18] = 0.0f;
		}
		for (int l19 = 0; l19 < 3; l19 = l19 + 1) {
			fRec22[l19] = 0.0f;
		}
		for (int l20 = 0; l20 < 3; l20 = l20 + 1) {
			fRec21[l20] = 0.0f;
		}
		for (int l21 = 0; l21 < 3; l21 = l21 + 1) {
			fRec20[l21] = 0.0f;
		}
		for (int l22 = 0; l22 < 3; l22 = l22 + 1) {
			fRec19[l22] = 0.0f;
		}
		for (int l23 = 0; l23 < 3; l23 = l23 + 1) {
			fRec18[l23] = 0.0f;
		}
		for (int l24 = 0; l24 < 3; l24 = l24 + 1) {
			fRec17[l24] = 0.0f;
		}
		for (int l25 = 0; l25 < 3; l25 = l25 + 1) {
			fRec16[l25] = 0.0f;
		}
		for (int l26 = 0; l26 < 3; l26 = l26 + 1) {
			fRec15[l26] = 0.0f;
		}
		for (int l27 = 0; l27 < 3; l27 = l27 + 1) {
			fRec14[l27] = 0.0f;
		}
		for (int l28 = 0; l28 < 3; l28 = l28 + 1) {
			fRec13[l28] = 0.0f;
		}
		for (int l29 = 0; l29 < 3; l29 = l29 + 1) {
			fRec12[l29] = 0.0f;
		}
		for (int l30 = 0; l30 < 3; l30 = l30 + 1) {
			fRec11[l30] = 0.0f;
		}
		for (int l31 = 0; l31 < 3; l31 = l31 + 1) {
			fRec10[l31] = 0.0f;
		}
		for (int l32 = 0; l32 < 3; l32 = l32 + 1) {
			fRec9[l32] = 0.0f;
		}
		for (int l33 = 0; l33 < 3; l33 = l33 + 1) {
			fRec8[l33] = 0.0f;
		}
		for (int l34 = 0; l34 < 3; l34 = l34 + 1) {
			fRec7[l34] = 0.0f;
		}
		for (int l35 = 0; l35 < 3; l35 = l35 + 1) {
			fRec6[l35] = 0.0f;
		}
		for (int l36 = 0; l36 < 3; l36 = l36 + 1) {
			fRec5[l36] = 0.0f;
		}
		for (int l37 = 0; l37 < 3; l37 = l37 + 1) {
			fRec4[l37] = 0.0f;
		}
		for (int l38 = 0; l38 < 3; l38 = l38 + 1) {
			fRec3[l38] = 0.0f;
		}
		for (int l39 = 0; l39 < 3; l39 = l39 + 1) {
			fRec2[l39] = 0.0f;
		}
		for (int l40 = 0; l40 < 2; l40 = l40 + 1) {
			fVec2[l40] = 0.0f;
		}
		for (int l41 = 0; l41 < 3; l41 = l41 + 1) {
			fRec1[l41] = 0.0f;
		}
		for (int l42 = 0; l42 < 2; l42 = l42 + 1) {
			iRec40[l42] = 0;
		}
		for (int l43 = 0; l43 < 2; l43 = l43 + 1) {
			iVec3[l43] = 0;
		}
		for (int l44 = 0; l44 < 2; l44 = l44 + 1) {
			fVec4[l44] = 0.0f;
		}
		for (int l45 = 0; l45 < 2; l45 = l45 + 1) {
			fRec41[l45] = 0.0f;
		}
		for (int l46 = 0; l46 < 2; l46 = l46 + 1) {
			iRec42[l46] = 0;
		}
		for (int l47 = 0; l47 < 2; l47 = l47 + 1) {
			fVec5[l47] = 0.0f;
		}
		for (int l48 = 0; l48 < 2; l48 = l48 + 1) {
			fRec43[l48] = 0.0f;
		}
		for (int l49 = 0; l49 < 2; l49 = l49 + 1) {
			iRec46[l49] = 0;
		}
		for (int l50 = 0; l50 < 2; l50 = l50 + 1) {
			fRec51[l50] = 0.0f;
		}
		for (int l51 = 0; l51 < 2; l51 = l51 + 1) {
			fVec6[l51] = 0.0f;
		}
		for (int l52 = 0; l52 < 2; l52 = l52 + 1) {
			fRec50[l52] = 0.0f;
		}
		for (int l53 = 0; l53 < 2; l53 = l53 + 1) {
			iVec7[l53] = 0;
		}
		for (int l54 = 0; l54 < 2; l54 = l54 + 1) {
			iRec52[l54] = 0;
		}
		for (int l55 = 0; l55 < 33554432; l55 = l55 + 1) {
			iVec8[l55] = 0;
		}
		for (int l56 = 0; l56 < 2; l56 = l56 + 1) {
			fRec53[l56] = 0.0f;
		}
		for (int l57 = 0; l57 < 2; l57 = l57 + 1) {
			iVec9[l57] = 0;
		}
		for (int l58 = 0; l58 < 2; l58 = l58 + 1) {
			iRec49[l58] = 0;
		}
		for (int l59 = 0; l59 < 2; l59 = l59 + 1) {
			iVec10[l59] = 0;
		}
		for (int l60 = 0; l60 < 2; l60 = l60 + 1) {
			fRec47[l60] = 0.0f;
		}
		for (int l61 = 0; l61 < 2; l61 = l61 + 1) {
			fRec48[l61] = 0.0f;
		}
		for (int l62 = 0; l62 < 2; l62 = l62 + 1) {
			fRec54[l62] = 0.0f;
		}
		for (int l63 = 0; l63 < 2; l63 = l63 + 1) {
			iRec56[l63] = 0;
		}
		for (int l64 = 0; l64 < 2; l64 = l64 + 1) {
			iRec57[l64] = 0;
		}
		for (int l65 = 0; l65 < 2; l65 = l65 + 1) {
			iRec55[l65] = 0;
		}
		for (int l66 = 0; l66 < 2; l66 = l66 + 1) {
			fRec59[l66] = 0.0f;
		}
		for (int l67 = 0; l67 < 2; l67 = l67 + 1) {
			fRec58[l67] = 0.0f;
		}
		for (int l68 = 0; l68 < 2; l68 = l68 + 1) {
			fRec61[l68] = 0.0f;
		}
		for (int l69 = 0; l69 < 2; l69 = l69 + 1) {
			fRec60[l69] = 0.0f;
		}
		for (int l70 = 0; l70 < 3; l70 = l70 + 1) {
			fRec45[l70] = 0.0f;
		}
		for (int l71 = 0; l71 < 3; l71 = l71 + 1) {
			fRec44[l71] = 0.0f;
		}
		for (int l72 = 0; l72 < 3; l72 = l72 + 1) {
			fRec62[l72] = 0.0f;
		}
		for (int l73 = 0; l73 < 3; l73 = l73 + 1) {
			fRec64[l73] = 0.0f;
		}
		for (int l74 = 0; l74 < 3; l74 = l74 + 1) {
			fRec63[l74] = 0.0f;
		}
		for (int l75 = 0; l75 < 3; l75 = l75 + 1) {
			fRec65[l75] = 0.0f;
		}
		for (int l76 = 0; l76 < 3; l76 = l76 + 1) {
			fRec67[l76] = 0.0f;
		}
		for (int l77 = 0; l77 < 3; l77 = l77 + 1) {
			fRec66[l77] = 0.0f;
		}
		for (int l78 = 0; l78 < 3; l78 = l78 + 1) {
			fRec68[l78] = 0.0f;
		}
		for (int l79 = 0; l79 < 3; l79 = l79 + 1) {
			fRec70[l79] = 0.0f;
		}
		for (int l80 = 0; l80 < 3; l80 = l80 + 1) {
			fRec69[l80] = 0.0f;
		}
		for (int l81 = 0; l81 < 3; l81 = l81 + 1) {
			fRec71[l81] = 0.0f;
		}
		for (int l82 = 0; l82 < 3; l82 = l82 + 1) {
			fRec73[l82] = 0.0f;
		}
		for (int l83 = 0; l83 < 3; l83 = l83 + 1) {
			fRec72[l83] = 0.0f;
		}
		for (int l84 = 0; l84 < 3; l84 = l84 + 1) {
			fRec74[l84] = 0.0f;
		}
		for (int l85 = 0; l85 < 3; l85 = l85 + 1) {
			fRec76[l85] = 0.0f;
		}
		for (int l86 = 0; l86 < 3; l86 = l86 + 1) {
			fRec75[l86] = 0.0f;
		}
		for (int l87 = 0; l87 < 3; l87 = l87 + 1) {
			fRec77[l87] = 0.0f;
		}
		for (int l88 = 0; l88 < 3; l88 = l88 + 1) {
			fRec79[l88] = 0.0f;
		}
		for (int l89 = 0; l89 < 3; l89 = l89 + 1) {
			fRec78[l89] = 0.0f;
		}
		for (int l90 = 0; l90 < 3; l90 = l90 + 1) {
			fRec80[l90] = 0.0f;
		}
		for (int l91 = 0; l91 < 3; l91 = l91 + 1) {
			fRec82[l91] = 0.0f;
		}
		for (int l92 = 0; l92 < 3; l92 = l92 + 1) {
			fRec81[l92] = 0.0f;
		}
		for (int l93 = 0; l93 < 3; l93 = l93 + 1) {
			fRec83[l93] = 0.0f;
		}
		for (int l94 = 0; l94 < 3; l94 = l94 + 1) {
			fRec85[l94] = 0.0f;
		}
		for (int l95 = 0; l95 < 3; l95 = l95 + 1) {
			fRec84[l95] = 0.0f;
		}
		for (int l96 = 0; l96 < 3; l96 = l96 + 1) {
			fRec86[l96] = 0.0f;
		}
		for (int l97 = 0; l97 < 3; l97 = l97 + 1) {
			fRec88[l97] = 0.0f;
		}
		for (int l98 = 0; l98 < 3; l98 = l98 + 1) {
			fRec87[l98] = 0.0f;
		}
		for (int l99 = 0; l99 < 3; l99 = l99 + 1) {
			fRec89[l99] = 0.0f;
		}
		for (int l100 = 0; l100 < 3; l100 = l100 + 1) {
			fRec91[l100] = 0.0f;
		}
		for (int l101 = 0; l101 < 3; l101 = l101 + 1) {
			fRec90[l101] = 0.0f;
		}
		for (int l102 = 0; l102 < 3; l102 = l102 + 1) {
			fRec92[l102] = 0.0f;
		}
		for (int l103 = 0; l103 < 3; l103 = l103 + 1) {
			fRec94[l103] = 0.0f;
		}
		for (int l104 = 0; l104 < 3; l104 = l104 + 1) {
			fRec93[l104] = 0.0f;
		}
		for (int l105 = 0; l105 < 3; l105 = l105 + 1) {
			fRec95[l105] = 0.0f;
		}
		for (int l106 = 0; l106 < 3; l106 = l106 + 1) {
			fRec97[l106] = 0.0f;
		}
		for (int l107 = 0; l107 < 3; l107 = l107 + 1) {
			fRec96[l107] = 0.0f;
		}
		for (int l108 = 0; l108 < 3; l108 = l108 + 1) {
			fRec98[l108] = 0.0f;
		}
		for (int l109 = 0; l109 < 3; l109 = l109 + 1) {
			fRec100[l109] = 0.0f;
		}
		for (int l110 = 0; l110 < 3; l110 = l110 + 1) {
			fRec99[l110] = 0.0f;
		}
		for (int l111 = 0; l111 < 3; l111 = l111 + 1) {
			fRec101[l111] = 0.0f;
		}
		for (int l112 = 0; l112 < 3; l112 = l112 + 1) {
			fRec103[l112] = 0.0f;
		}
		for (int l113 = 0; l113 < 3; l113 = l113 + 1) {
			fRec102[l113] = 0.0f;
		}
		for (int l114 = 0; l114 < 3; l114 = l114 + 1) {
			fRec104[l114] = 0.0f;
		}
		for (int l115 = 0; l115 < 3; l115 = l115 + 1) {
			fRec106[l115] = 0.0f;
		}
		for (int l116 = 0; l116 < 3; l116 = l116 + 1) {
			fRec105[l116] = 0.0f;
		}
		for (int l117 = 0; l117 < 3; l117 = l117 + 1) {
			fRec107[l117] = 0.0f;
		}
		for (int l118 = 0; l118 < 3; l118 = l118 + 1) {
			fRec109[l118] = 0.0f;
		}
		for (int l119 = 0; l119 < 3; l119 = l119 + 1) {
			fRec108[l119] = 0.0f;
		}
		for (int l120 = 0; l120 < 3; l120 = l120 + 1) {
			fRec110[l120] = 0.0f;
		}
		for (int l121 = 0; l121 < 3; l121 = l121 + 1) {
			fRec112[l121] = 0.0f;
		}
		for (int l122 = 0; l122 < 3; l122 = l122 + 1) {
			fRec111[l122] = 0.0f;
		}
		for (int l123 = 0; l123 < 3; l123 = l123 + 1) {
			fRec113[l123] = 0.0f;
		}
		for (int l124 = 0; l124 < 3; l124 = l124 + 1) {
			fRec115[l124] = 0.0f;
		}
		for (int l125 = 0; l125 < 3; l125 = l125 + 1) {
			fRec114[l125] = 0.0f;
		}
		for (int l126 = 0; l126 < 3; l126 = l126 + 1) {
			fRec116[l126] = 0.0f;
		}
		for (int l127 = 0; l127 < 3; l127 = l127 + 1) {
			fRec118[l127] = 0.0f;
		}
		for (int l128 = 0; l128 < 3; l128 = l128 + 1) {
			fRec117[l128] = 0.0f;
		}
		for (int l129 = 0; l129 < 3; l129 = l129 + 1) {
			fRec119[l129] = 0.0f;
		}
		for (int l130 = 0; l130 < 3; l130 = l130 + 1) {
			fRec121[l130] = 0.0f;
		}
		for (int l131 = 0; l131 < 3; l131 = l131 + 1) {
			fRec120[l131] = 0.0f;
		}
		for (int l132 = 0; l132 < 3; l132 = l132 + 1) {
			fRec122[l132] = 0.0f;
		}
		for (int l133 = 0; l133 < 3; l133 = l133 + 1) {
			fRec124[l133] = 0.0f;
		}
		for (int l134 = 0; l134 < 3; l134 = l134 + 1) {
			fRec123[l134] = 0.0f;
		}
		for (int l135 = 0; l135 < 3; l135 = l135 + 1) {
			fRec125[l135] = 0.0f;
		}
		for (int l136 = 0; l136 < 3; l136 = l136 + 1) {
			fRec127[l136] = 0.0f;
		}
		for (int l137 = 0; l137 < 3; l137 = l137 + 1) {
			fRec126[l137] = 0.0f;
		}
		for (int l138 = 0; l138 < 3; l138 = l138 + 1) {
			fRec128[l138] = 0.0f;
		}
		for (int l139 = 0; l139 < 3; l139 = l139 + 1) {
			fRec130[l139] = 0.0f;
		}
		for (int l140 = 0; l140 < 3; l140 = l140 + 1) {
			fRec129[l140] = 0.0f;
		}
		for (int l141 = 0; l141 < 3; l141 = l141 + 1) {
			fRec131[l141] = 0.0f;
		}
		for (int l142 = 0; l142 < 3; l142 = l142 + 1) {
			fRec133[l142] = 0.0f;
		}
		for (int l143 = 0; l143 < 3; l143 = l143 + 1) {
			fRec132[l143] = 0.0f;
		}
		for (int l144 = 0; l144 < 3; l144 = l144 + 1) {
			fRec134[l144] = 0.0f;
		}
		for (int l145 = 0; l145 < 3; l145 = l145 + 1) {
			fRec136[l145] = 0.0f;
		}
		for (int l146 = 0; l146 < 3; l146 = l146 + 1) {
			fRec135[l146] = 0.0f;
		}
		for (int l147 = 0; l147 < 3; l147 = l147 + 1) {
			fRec137[l147] = 0.0f;
		}
		for (int l148 = 0; l148 < 3; l148 = l148 + 1) {
			fRec139[l148] = 0.0f;
		}
		for (int l149 = 0; l149 < 3; l149 = l149 + 1) {
			fRec138[l149] = 0.0f;
		}
		for (int l150 = 0; l150 < 3; l150 = l150 + 1) {
			fRec140[l150] = 0.0f;
		}
		for (int l151 = 0; l151 < 3; l151 = l151 + 1) {
			fRec142[l151] = 0.0f;
		}
		for (int l152 = 0; l152 < 3; l152 = l152 + 1) {
			fRec141[l152] = 0.0f;
		}
		for (int l153 = 0; l153 < 3; l153 = l153 + 1) {
			fRec143[l153] = 0.0f;
		}
		for (int l154 = 0; l154 < 3; l154 = l154 + 1) {
			fRec145[l154] = 0.0f;
		}
		for (int l155 = 0; l155 < 3; l155 = l155 + 1) {
			fRec144[l155] = 0.0f;
		}
		for (int l156 = 0; l156 < 3; l156 = l156 + 1) {
			fRec146[l156] = 0.0f;
		}
		for (int l157 = 0; l157 < 3; l157 = l157 + 1) {
			fRec148[l157] = 0.0f;
		}
		for (int l158 = 0; l158 < 3; l158 = l158 + 1) {
			fRec147[l158] = 0.0f;
		}
		for (int l159 = 0; l159 < 3; l159 = l159 + 1) {
			fRec149[l159] = 0.0f;
		}
		for (int l160 = 0; l160 < 3; l160 = l160 + 1) {
			fRec151[l160] = 0.0f;
		}
		for (int l161 = 0; l161 < 3; l161 = l161 + 1) {
			fRec150[l161] = 0.0f;
		}
		for (int l162 = 0; l162 < 3; l162 = l162 + 1) {
			fRec152[l162] = 0.0f;
		}
		for (int l163 = 0; l163 < 3; l163 = l163 + 1) {
			fRec154[l163] = 0.0f;
		}
		for (int l164 = 0; l164 < 3; l164 = l164 + 1) {
			fRec153[l164] = 0.0f;
		}
		for (int l165 = 0; l165 < 3; l165 = l165 + 1) {
			fRec155[l165] = 0.0f;
		}
		for (int l166 = 0; l166 < 4194304; l166 = l166 + 1) {
			fRec0[l166] = 0.0f;
		}
		for (int l167 = 0; l167 < 2; l167 = l167 + 1) {
			fRec192[l167] = 0.0f;
		}
		for (int l168 = 0; l168 < 3; l168 = l168 + 1) {
			fRec191[l168] = 0.0f;
		}
		for (int l169 = 0; l169 < 3; l169 = l169 + 1) {
			fRec190[l169] = 0.0f;
		}
		for (int l170 = 0; l170 < 512; l170 = l170 + 1) {
			fVec11[l170] = 0.0f;
		}
		for (int l171 = 0; l171 < 3; l171 = l171 + 1) {
			fRec189[l171] = 0.0f;
		}
		for (int l172 = 0; l172 < 3; l172 = l172 + 1) {
			fRec188[l172] = 0.0f;
		}
		for (int l173 = 0; l173 < 3; l173 = l173 + 1) {
			fRec187[l173] = 0.0f;
		}
		for (int l174 = 0; l174 < 3; l174 = l174 + 1) {
			fRec186[l174] = 0.0f;
		}
		for (int l175 = 0; l175 < 3; l175 = l175 + 1) {
			fRec185[l175] = 0.0f;
		}
		for (int l176 = 0; l176 < 3; l176 = l176 + 1) {
			fRec184[l176] = 0.0f;
		}
		for (int l177 = 0; l177 < 3; l177 = l177 + 1) {
			fRec183[l177] = 0.0f;
		}
		for (int l178 = 0; l178 < 3; l178 = l178 + 1) {
			fRec182[l178] = 0.0f;
		}
		for (int l179 = 0; l179 < 3; l179 = l179 + 1) {
			fRec181[l179] = 0.0f;
		}
		for (int l180 = 0; l180 < 3; l180 = l180 + 1) {
			fRec180[l180] = 0.0f;
		}
		for (int l181 = 0; l181 < 3; l181 = l181 + 1) {
			fRec179[l181] = 0.0f;
		}
		for (int l182 = 0; l182 < 3; l182 = l182 + 1) {
			fRec178[l182] = 0.0f;
		}
		for (int l183 = 0; l183 < 3; l183 = l183 + 1) {
			fRec177[l183] = 0.0f;
		}
		for (int l184 = 0; l184 < 3; l184 = l184 + 1) {
			fRec176[l184] = 0.0f;
		}
		for (int l185 = 0; l185 < 3; l185 = l185 + 1) {
			fRec175[l185] = 0.0f;
		}
		for (int l186 = 0; l186 < 3; l186 = l186 + 1) {
			fRec174[l186] = 0.0f;
		}
		for (int l187 = 0; l187 < 3; l187 = l187 + 1) {
			fRec173[l187] = 0.0f;
		}
		for (int l188 = 0; l188 < 3; l188 = l188 + 1) {
			fRec172[l188] = 0.0f;
		}
		for (int l189 = 0; l189 < 3; l189 = l189 + 1) {
			fRec171[l189] = 0.0f;
		}
		for (int l190 = 0; l190 < 3; l190 = l190 + 1) {
			fRec170[l190] = 0.0f;
		}
		for (int l191 = 0; l191 < 3; l191 = l191 + 1) {
			fRec169[l191] = 0.0f;
		}
		for (int l192 = 0; l192 < 3; l192 = l192 + 1) {
			fRec168[l192] = 0.0f;
		}
		for (int l193 = 0; l193 < 3; l193 = l193 + 1) {
			fRec167[l193] = 0.0f;
		}
		for (int l194 = 0; l194 < 3; l194 = l194 + 1) {
			fRec166[l194] = 0.0f;
		}
		for (int l195 = 0; l195 < 3; l195 = l195 + 1) {
			fRec165[l195] = 0.0f;
		}
		for (int l196 = 0; l196 < 3; l196 = l196 + 1) {
			fRec164[l196] = 0.0f;
		}
		for (int l197 = 0; l197 < 3; l197 = l197 + 1) {
			fRec163[l197] = 0.0f;
		}
		for (int l198 = 0; l198 < 3; l198 = l198 + 1) {
			fRec162[l198] = 0.0f;
		}
		for (int l199 = 0; l199 < 3; l199 = l199 + 1) {
			fRec161[l199] = 0.0f;
		}
		for (int l200 = 0; l200 < 3; l200 = l200 + 1) {
			fRec160[l200] = 0.0f;
		}
		for (int l201 = 0; l201 < 3; l201 = l201 + 1) {
			fRec159[l201] = 0.0f;
		}
		for (int l202 = 0; l202 < 3; l202 = l202 + 1) {
			fRec158[l202] = 0.0f;
		}
		for (int l203 = 0; l203 < 2; l203 = l203 + 1) {
			fVec12[l203] = 0.0f;
		}
		for (int l204 = 0; l204 < 3; l204 = l204 + 1) {
			fRec157[l204] = 0.0f;
		}
		for (int l205 = 0; l205 < 4194304; l205 = l205 + 1) {
			fRec156[l205] = 0.0f;
		}
	}
	
	virtual void init(int sample_rate) {
		classInit(sample_rate);
		instanceInit(sample_rate);
	}
	
	virtual void instanceInit(int sample_rate) {
		instanceConstants(sample_rate);
		instanceResetUserInterface();
		instanceClear();
	}
	
	virtual mydsp* clone() {
		return new mydsp(*this);
	}
	
	virtual int getSampleRate() {
		return fSampleRate;
	}
	
	virtual void buildUserInterface(UI* ui_interface) {
		ui_interface->openHorizontalBox("Ambient machine");
		ui_interface->openVerticalBox("binary decoders");
		ui_interface->declare(0, "0", "");
		ui_interface->openVerticalBox("Main clock");
		ui_interface->addCheckButton("Run!", &fCheckbox0);
		ui_interface->addVerticalSlider("bpm", &fVslider4, FAUSTFLOAT(8e+01f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(1e+02f), FAUSTFLOAT(1.0f));
		ui_interface->closeBox();
		ui_interface->declare(&fVslider8, "0", "");
		ui_interface->declare(&fVslider8, "style", "knob");
		ui_interface->addVerticalSlider("note seq", &fVslider8, FAUSTFLOAT(0.9f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->declare(&fVslider5, "1", "");
		ui_interface->declare(&fVslider5, "style", "knob");
		ui_interface->addVerticalSlider("trig %", &fVslider5, FAUSTFLOAT(0.5f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->declare(&fVslider6, "4", "");
		ui_interface->declare(&fVslider6, "style", "knob");
		ui_interface->addVerticalSlider("Exite shape", &fVslider6, FAUSTFLOAT(0.25f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->closeBox();
		ui_interface->openVerticalBox("echo");
		ui_interface->declare(&fHslider1, "0", "");
		ui_interface->declare(&fHslider1, "style", "knob");
		ui_interface->addHorizontalSlider("Duration", &fHslider1, FAUSTFLOAT(5e+02f), FAUSTFLOAT(1.0f), FAUSTFLOAT(1e+03f), FAUSTFLOAT(1.0f));
		ui_interface->declare(&fHslider0, "1", "");
		ui_interface->declare(&fHslider0, "style", "knob");
		ui_interface->addHorizontalSlider("Feedback", &fHslider0, FAUSTFLOAT(0.75f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->declare(&fHslider2, "style", "knob");
		ui_interface->addHorizontalSlider("disp", &fHslider2, FAUSTFLOAT(0.5f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->addVerticalSlider("wet", &fVslider0, FAUSTFLOAT(0.5f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->closeBox();
		ui_interface->openHorizontalBox("rez");
		ui_interface->addVerticalSlider("Decay", &fVslider10, FAUSTFLOAT(0.2f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.01f));
		ui_interface->addVerticalSlider("Hsprd", &fVslider9, FAUSTFLOAT(0.0f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.001f));
		ui_interface->addVerticalSlider("bpm", &fVslider1, FAUSTFLOAT(8e+01f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(1e+02f), FAUSTFLOAT(1.0f));
		ui_interface->addVerticalSlider("freq", &fVslider7, FAUSTFLOAT(1e+02f), FAUSTFLOAT(1e+01f), FAUSTFLOAT(8e+02f), FAUSTFLOAT(1.0f));
		ui_interface->addVerticalSlider("n.o.h", &fVslider3, FAUSTFLOAT(4.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(32.0f), FAUSTFLOAT(1.0f));
		ui_interface->addVerticalSlider("oddlvl", &fVslider2, FAUSTFLOAT(0.5f), FAUSTFLOAT(0.0f), FAUSTFLOAT(1.0f), FAUSTFLOAT(0.001f));
		ui_interface->closeBox();
		ui_interface->closeBox();
	}
	
	virtual void compute(int count, FAUSTFLOAT** RESTRICT inputs, FAUSTFLOAT** RESTRICT outputs) {
		FAUSTFLOAT* output0 = outputs[0];
		FAUSTFLOAT* output1 = outputs[1];
		float fSlow0 = static_cast<float>(fVslider0);
		float fSlow1 = static_cast<float>(fHslider0);
		float fSlow2 = 1e-06f * static_cast<float>(fHslider1);
		float fSlow3 = static_cast<float>(fHslider2);
		float fSlow4 = std::max<float>(0.01f, 6e+01f * fSlow3 + 1.0f);
		float fSlow5 = 0.015705379f / fSlow4;
		float fSlow6 = 1.0f / (fSlow5 + 1.0f);
		float fSlow7 = 1.0f - fSlow5;
		float fSlow8 = std::max<float>(0.01f, 5e+01f * fSlow3 + 1.0f);
		float fSlow9 = 0.015705379f / fSlow8;
		float fSlow10 = 1.0f / (fSlow9 + 1.0f);
		float fSlow11 = 1.0f - fSlow9;
		float fSlow12 = 0.5f / fSlow4;
		float fSlow13 = 0.5f / fSlow8;
		int iSlow14 = static_cast<int>(fConst18 / static_cast<float>(fVslider1));
		float fSlow15 = static_cast<float>(fVslider2);
		int iSlow16 = fSlow15 <= 0.2f;
		float fSlow17 = static_cast<float>(fVslider3);
		int iSlow18 = fSlow17 <= 4.0f;
		int iSlow19 = static_cast<int>(fSlow17);
		int iSlow20 = static_cast<int>(1.0f - static_cast<float>(fCheckbox0));
		float fSlow21 = fConst19 * static_cast<float>(fVslider4);
		float fSlow22 = static_cast<float>(fVslider5);
		float fSlow23 = fConst21 * static_cast<float>(fVslider6);
		float fSlow24 = fConst21 * static_cast<float>(fVslider7);
		float fSlow25 = static_cast<float>(fVslider8);
		float fSlow26 = 0.2f * static_cast<float>(fVslider9);
		float fSlow27 = fConst21 * static_cast<float>(fVslider10);
		float fSlow28 = 0.5f * (1.0f - fSlow0);
		for (int i0 = 0; i0 < count; i0 = i0 + 1) {
			iVec0[0] = 1;
			fRec36[0] = fSlow2 + 0.999f * fRec36[1];
			fRec35[0] = fSlow1 * fRec0[(IOTA0 - (static_cast<int>(std::min<float>(fConst10, std::max<float>(0.0f, fConst0 * fRec36[0] + -1.0f))) + 1)) & 4194303] - fConst9 * (fConst11 * fRec35[2] + fConst12 * fRec35[1]);
			fRec34[0] = fConst9 * (fRec35[2] + fRec35[0] + 2.0f * fRec35[1]) - fConst8 * (fConst13 * fRec34[2] + fConst12 * fRec34[1]);
			fVec1[IOTA0 & 511] = fRec34[2] + fRec34[0] + 2.0f * fRec34[1];
			iRec38[0] = (iVec0[1] + iRec38[1]) % 600000;
			iRec39[0] = (iVec0[1] + iRec39[1]) % 700201;
			fRec37[0] = 0.01f * (std::sin(1.0471976e-05f * static_cast<float>(iRec38[0])) * std::sin(8.973402e-06f * static_cast<float>(iRec39[0])) + 1.0f) + 0.99f * fRec37[1];
			float fTemp0 = 1.9990131f * fRec33[1];
			fRec33[0] = fConst8 * fVec1[(IOTA0 - static_cast<int>(std::min<float>(4e+02f, std::max<float>(0.0f, 3e+03f * fRec37[0])))) & 511] - fSlow6 * (fSlow7 * fRec33[2] - fTemp0);
			float fTemp1 = 1.9990131f * fRec32[1];
			fRec32[0] = fRec33[2] + fSlow6 * (fSlow7 * fRec33[0] - fTemp0) - fSlow10 * (fSlow11 * fRec32[2] - fTemp1);
			float fTemp2 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(3e+01f * fRec37[0], 2e+03f) + 1e+02f), 0.99f));
			float fTemp3 = fSlow12 * std::sin(fTemp2);
			float fTemp4 = 1.0f - fTemp3;
			float fTemp5 = std::cos(fTemp2);
			float fTemp6 = 2.0f * fRec31[1] * fTemp5;
			float fTemp7 = fTemp3 + 1.0f;
			fRec31[0] = fRec32[2] + fSlow10 * (fSlow11 * fRec32[0] - fTemp1) - (fRec31[2] * fTemp4 - fTemp6) / fTemp7;
			float fTemp8 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1e+02f - std::fmod(7e+01f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp9 = fSlow13 * std::sin(fTemp8);
			float fTemp10 = 1.0f - fTemp9;
			float fTemp11 = std::cos(fTemp8);
			float fTemp12 = 2.0f * fRec30[1] * fTemp11;
			float fTemp13 = fTemp9 + 1.0f;
			fRec30[0] = fRec31[2] + (fRec31[0] * fTemp4 - fTemp6) / fTemp7 - (fRec30[2] * fTemp10 - fTemp12) / fTemp13;
			float fTemp14 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(6e+01f * fRec37[0], 2e+03f) + 2e+02f), 0.99f));
			float fTemp15 = fSlow12 * std::sin(fTemp14);
			float fTemp16 = 1.0f - fTemp15;
			float fTemp17 = std::cos(fTemp14);
			float fTemp18 = 2.0f * fRec29[1] * fTemp17;
			float fTemp19 = fTemp15 + 1.0f;
			fRec29[0] = fRec30[2] + (fRec30[0] * fTemp10 - fTemp12) / fTemp13 - (fRec29[2] * fTemp16 - fTemp18) / fTemp19;
			float fTemp20 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (2e+02f - std::fmod(1.4e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp21 = fSlow13 * std::sin(fTemp20);
			float fTemp22 = 1.0f - fTemp21;
			float fTemp23 = std::cos(fTemp20);
			float fTemp24 = 2.0f * fRec28[1] * fTemp23;
			float fTemp25 = fTemp21 + 1.0f;
			fRec28[0] = fRec29[2] + (fRec29[0] * fTemp16 - fTemp18) / fTemp19 - (fRec28[2] * fTemp22 - fTemp24) / fTemp25;
			float fTemp26 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(9e+01f * fRec37[0], 2e+03f) + 3e+02f), 0.99f));
			float fTemp27 = fSlow12 * std::sin(fTemp26);
			float fTemp28 = 1.0f - fTemp27;
			float fTemp29 = std::cos(fTemp26);
			float fTemp30 = 2.0f * fRec27[1] * fTemp29;
			float fTemp31 = fTemp27 + 1.0f;
			fRec27[0] = fRec28[2] + (fRec28[0] * fTemp22 - fTemp24) / fTemp25 - (fRec27[2] * fTemp28 - fTemp30) / fTemp31;
			float fTemp32 = std::fmod(2.1e+02f * fRec37[0], 2e+03f);
			float fTemp33 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (3e+02f - fTemp32), 0.99f));
			float fTemp34 = fSlow13 * std::sin(fTemp33);
			float fTemp35 = 1.0f - fTemp34;
			float fTemp36 = std::cos(fTemp33);
			float fTemp37 = 2.0f * fRec26[1] * fTemp36;
			float fTemp38 = fTemp34 + 1.0f;
			fRec26[0] = fRec27[2] + (fRec27[0] * fTemp28 - fTemp30) / fTemp31 - (fRec26[2] * fTemp35 - fTemp37) / fTemp38;
			float fTemp39 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(1.2e+02f * fRec37[0], 2e+03f) + 4e+02f), 0.99f));
			float fTemp40 = fSlow12 * std::sin(fTemp39);
			float fTemp41 = 1.0f - fTemp40;
			float fTemp42 = std::cos(fTemp39);
			float fTemp43 = 2.0f * fRec25[1] * fTemp42;
			float fTemp44 = fTemp40 + 1.0f;
			fRec25[0] = fRec26[2] + (fRec26[0] * fTemp35 - fTemp37) / fTemp38 - (fRec25[2] * fTemp41 - fTemp43) / fTemp44;
			float fTemp45 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (4e+02f - std::fmod(2.8e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp46 = fSlow13 * std::sin(fTemp45);
			float fTemp47 = 1.0f - fTemp46;
			float fTemp48 = std::cos(fTemp45);
			float fTemp49 = 2.0f * fRec24[1] * fTemp48;
			float fTemp50 = fTemp46 + 1.0f;
			fRec24[0] = fRec25[2] + (fRec25[0] * fTemp41 - fTemp43) / fTemp44 - (fRec24[2] * fTemp47 - fTemp49) / fTemp50;
			float fTemp51 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(1.5e+02f * fRec37[0], 2e+03f) + 5e+02f), 0.99f));
			float fTemp52 = fSlow12 * std::sin(fTemp51);
			float fTemp53 = 1.0f - fTemp52;
			float fTemp54 = std::cos(fTemp51);
			float fTemp55 = 2.0f * fRec23[1] * fTemp54;
			float fTemp56 = fTemp52 + 1.0f;
			fRec23[0] = fRec24[2] + (fRec24[0] * fTemp47 - fTemp49) / fTemp50 - (fRec23[2] * fTemp53 - fTemp55) / fTemp56;
			float fTemp57 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (5e+02f - std::fmod(3.5e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp58 = fSlow13 * std::sin(fTemp57);
			float fTemp59 = 1.0f - fTemp58;
			float fTemp60 = std::cos(fTemp57);
			float fTemp61 = 2.0f * fRec22[1] * fTemp60;
			float fTemp62 = fTemp58 + 1.0f;
			fRec22[0] = fRec23[2] + (fRec23[0] * fTemp53 - fTemp55) / fTemp56 - (fRec22[2] * fTemp59 - fTemp61) / fTemp62;
			float fTemp63 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(1.8e+02f * fRec37[0], 2e+03f) + 6e+02f), 0.99f));
			float fTemp64 = fSlow12 * std::sin(fTemp63);
			float fTemp65 = 1.0f - fTemp64;
			float fTemp66 = std::cos(fTemp63);
			float fTemp67 = 2.0f * fRec21[1] * fTemp66;
			float fTemp68 = fTemp64 + 1.0f;
			fRec21[0] = fRec22[2] + (fRec22[0] * fTemp59 - fTemp61) / fTemp62 - (fRec21[2] * fTemp65 - fTemp67) / fTemp68;
			float fTemp69 = std::fmod(4.2e+02f * fRec37[0], 2e+03f);
			float fTemp70 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (6e+02f - fTemp69), 0.99f));
			float fTemp71 = fSlow13 * std::sin(fTemp70);
			float fTemp72 = 1.0f - fTemp71;
			float fTemp73 = std::cos(fTemp70);
			float fTemp74 = 2.0f * fRec20[1] * fTemp73;
			float fTemp75 = fTemp71 + 1.0f;
			fRec20[0] = fRec21[2] + (fRec21[0] * fTemp65 - fTemp67) / fTemp68 - (fRec20[2] * fTemp72 - fTemp74) / fTemp75;
			float fTemp76 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (fTemp32 + 7e+02f), 0.99f));
			float fTemp77 = fSlow12 * std::sin(fTemp76);
			float fTemp78 = 1.0f - fTemp77;
			float fTemp79 = std::cos(fTemp76);
			float fTemp80 = 2.0f * fRec19[1] * fTemp79;
			float fTemp81 = fTemp77 + 1.0f;
			fRec19[0] = fRec20[2] + (fRec20[0] * fTemp72 - fTemp74) / fTemp75 - (fRec19[2] * fTemp78 - fTemp80) / fTemp81;
			float fTemp82 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (7e+02f - std::fmod(4.9e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp83 = fSlow13 * std::sin(fTemp82);
			float fTemp84 = 1.0f - fTemp83;
			float fTemp85 = std::cos(fTemp82);
			float fTemp86 = 2.0f * fRec18[1] * fTemp85;
			float fTemp87 = fTemp83 + 1.0f;
			fRec18[0] = fRec19[2] + (fRec19[0] * fTemp78 - fTemp80) / fTemp81 - (fRec18[2] * fTemp84 - fTemp86) / fTemp87;
			float fTemp88 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(2.4e+02f * fRec37[0], 2e+03f) + 8e+02f), 0.99f));
			float fTemp89 = fSlow12 * std::sin(fTemp88);
			float fTemp90 = 1.0f - fTemp89;
			float fTemp91 = std::cos(fTemp88);
			float fTemp92 = 2.0f * fRec17[1] * fTemp91;
			float fTemp93 = fTemp89 + 1.0f;
			fRec17[0] = fRec18[2] + (fRec18[0] * fTemp84 - fTemp86) / fTemp87 - (fRec17[2] * fTemp90 - fTemp92) / fTemp93;
			float fTemp94 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (8e+02f - std::fmod(5.6e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp95 = fSlow13 * std::sin(fTemp94);
			float fTemp96 = 1.0f - fTemp95;
			float fTemp97 = std::cos(fTemp94);
			float fTemp98 = 2.0f * fRec16[1] * fTemp97;
			float fTemp99 = fTemp95 + 1.0f;
			fRec16[0] = fRec17[2] + (fRec17[0] * fTemp90 - fTemp92) / fTemp93 - (fRec16[2] * fTemp96 - fTemp98) / fTemp99;
			float fTemp100 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(2.7e+02f * fRec37[0], 2e+03f) + 9e+02f), 0.99f));
			float fTemp101 = fSlow12 * std::sin(fTemp100);
			float fTemp102 = 1.0f - fTemp101;
			float fTemp103 = std::cos(fTemp100);
			float fTemp104 = 2.0f * fRec15[1] * fTemp103;
			float fTemp105 = fTemp101 + 1.0f;
			fRec15[0] = fRec16[2] + (fRec16[0] * fTemp96 - fTemp98) / fTemp99 - (fRec15[2] * fTemp102 - fTemp104) / fTemp105;
			float fTemp106 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (9e+02f - std::fmod(6.3e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp107 = fSlow13 * std::sin(fTemp106);
			float fTemp108 = 1.0f - fTemp107;
			float fTemp109 = std::cos(fTemp106);
			float fTemp110 = 2.0f * fRec14[1] * fTemp109;
			float fTemp111 = fTemp107 + 1.0f;
			fRec14[0] = fRec15[2] + (fRec15[0] * fTemp102 - fTemp104) / fTemp105 - (fRec14[2] * fTemp108 - fTemp110) / fTemp111;
			float fTemp112 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(3e+02f * fRec37[0], 2e+03f) + 1e+03f), 0.99f));
			float fTemp113 = fSlow12 * std::sin(fTemp112);
			float fTemp114 = 1.0f - fTemp113;
			float fTemp115 = std::cos(fTemp112);
			float fTemp116 = 2.0f * fRec13[1] * fTemp115;
			float fTemp117 = fTemp113 + 1.0f;
			fRec13[0] = fRec14[2] + (fRec14[0] * fTemp108 - fTemp110) / fTemp111 - (fRec13[2] * fTemp114 - fTemp116) / fTemp117;
			float fTemp118 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1e+03f - std::fmod(7e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp119 = fSlow13 * std::sin(fTemp118);
			float fTemp120 = 1.0f - fTemp119;
			float fTemp121 = std::cos(fTemp118);
			float fTemp122 = 2.0f * fRec12[1] * fTemp121;
			float fTemp123 = fTemp119 + 1.0f;
			fRec12[0] = fRec13[2] + (fRec13[0] * fTemp114 - fTemp116) / fTemp117 - (fRec12[2] * fTemp120 - fTemp122) / fTemp123;
			float fTemp124 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(3.3e+02f * fRec37[0], 2e+03f) + 1.1e+03f), 0.99f));
			float fTemp125 = fSlow12 * std::sin(fTemp124);
			float fTemp126 = 1.0f - fTemp125;
			float fTemp127 = std::cos(fTemp124);
			float fTemp128 = 2.0f * fRec11[1] * fTemp127;
			float fTemp129 = fTemp125 + 1.0f;
			fRec11[0] = fRec12[2] + (fRec12[0] * fTemp120 - fTemp122) / fTemp123 - (fRec11[2] * fTemp126 - fTemp128) / fTemp129;
			float fTemp130 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1.1e+03f - std::fmod(7.7e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp131 = fSlow13 * std::sin(fTemp130);
			float fTemp132 = 1.0f - fTemp131;
			float fTemp133 = std::cos(fTemp130);
			float fTemp134 = 2.0f * fRec10[1] * fTemp133;
			float fTemp135 = fTemp131 + 1.0f;
			fRec10[0] = fRec11[2] + (fRec11[0] * fTemp126 - fTemp128) / fTemp129 - (fRec10[2] * fTemp132 - fTemp134) / fTemp135;
			float fTemp136 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(3.6e+02f * fRec37[0], 2e+03f) + 1.2e+03f), 0.99f));
			float fTemp137 = fSlow12 * std::sin(fTemp136);
			float fTemp138 = 1.0f - fTemp137;
			float fTemp139 = std::cos(fTemp136);
			float fTemp140 = 2.0f * fRec9[1] * fTemp139;
			float fTemp141 = fTemp137 + 1.0f;
			fRec9[0] = fRec10[2] + (fRec10[0] * fTemp132 - fTemp134) / fTemp135 - (fRec9[2] * fTemp138 - fTemp140) / fTemp141;
			float fTemp142 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1.2e+03f - std::fmod(8.4e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp143 = fSlow13 * std::sin(fTemp142);
			float fTemp144 = 1.0f - fTemp143;
			float fTemp145 = std::cos(fTemp142);
			float fTemp146 = 2.0f * fRec8[1] * fTemp145;
			float fTemp147 = fTemp143 + 1.0f;
			fRec8[0] = fRec9[2] + (fRec9[0] * fTemp138 - fTemp140) / fTemp141 - (fRec8[2] * fTemp144 - fTemp146) / fTemp147;
			float fTemp148 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(3.9e+02f * fRec37[0], 2e+03f) + 1.3e+03f), 0.99f));
			float fTemp149 = fSlow12 * std::sin(fTemp148);
			float fTemp150 = 1.0f - fTemp149;
			float fTemp151 = std::cos(fTemp148);
			float fTemp152 = 2.0f * fRec7[1] * fTemp151;
			float fTemp153 = fTemp149 + 1.0f;
			fRec7[0] = fRec8[2] + (fRec8[0] * fTemp144 - fTemp146) / fTemp147 - (fRec7[2] * fTemp150 - fTemp152) / fTemp153;
			float fTemp154 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1.3e+03f - std::fmod(9.1e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp155 = fSlow13 * std::sin(fTemp154);
			float fTemp156 = 1.0f - fTemp155;
			float fTemp157 = std::cos(fTemp154);
			float fTemp158 = 2.0f * fRec6[1] * fTemp157;
			float fTemp159 = fTemp155 + 1.0f;
			fRec6[0] = fRec7[2] + (fRec7[0] * fTemp150 - fTemp152) / fTemp153 - (fRec6[2] * fTemp156 - fTemp158) / fTemp159;
			float fTemp160 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (fTemp69 + 1.4e+03f), 0.99f));
			float fTemp161 = fSlow12 * std::sin(fTemp160);
			float fTemp162 = 1.0f - fTemp161;
			float fTemp163 = std::cos(fTemp160);
			float fTemp164 = 2.0f * fRec5[1] * fTemp163;
			float fTemp165 = fTemp161 + 1.0f;
			fRec5[0] = fRec6[2] + (fRec6[0] * fTemp156 - fTemp158) / fTemp159 - (fRec5[2] * fTemp162 - fTemp164) / fTemp165;
			float fTemp166 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1.4e+03f - std::fmod(9.8e+02f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp167 = fSlow13 * std::sin(fTemp166);
			float fTemp168 = 1.0f - fTemp167;
			float fTemp169 = std::cos(fTemp166);
			float fTemp170 = 2.0f * fRec4[1] * fTemp169;
			float fTemp171 = fTemp167 + 1.0f;
			fRec4[0] = fRec5[2] + (fRec5[0] * fTemp162 - fTemp164) / fTemp165 - (fRec4[2] * fTemp168 - fTemp170) / fTemp171;
			float fTemp172 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (std::fmod(4.5e+02f * fRec37[0], 2e+03f) + 1.5e+03f), 0.99f));
			float fTemp173 = fSlow12 * std::sin(fTemp172);
			float fTemp174 = 1.0f - fTemp173;
			float fTemp175 = std::cos(fTemp172);
			float fTemp176 = 2.0f * fRec3[1] * fTemp175;
			float fTemp177 = fTemp173 + 1.0f;
			fRec3[0] = fRec4[2] + (fRec4[0] * fTemp168 - fTemp170) / fTemp171 - (fRec3[2] * fTemp174 - fTemp176) / fTemp177;
			float fTemp178 = 3.1415927f * std::max<float>(0.01f, std::min<float>(fConst14 * (1.5e+03f - std::fmod(1.05e+03f * fRec37[0], 2e+03f)), 0.99f));
			float fTemp179 = fSlow13 * std::sin(fTemp178);
			float fTemp180 = 1.0f - fTemp179;
			float fTemp181 = std::cos(fTemp178);
			float fTemp182 = 2.0f * fRec2[1] * fTemp181;
			float fTemp183 = fTemp179 + 1.0f;
			fRec2[0] = fRec3[2] + (fRec3[0] * fTemp174 - fTemp176) / fTemp177 - (fRec2[2] * fTemp180 - fTemp182) / fTemp183;
			float fTemp184 = fRec2[2] + (fRec2[0] * fTemp180 - fTemp182) / fTemp183;
			fVec2[0] = fTemp184;
			float fTemp185 = fTemp184 - fVec2[1];
			fRec1[0] = ((std::fabs(fTemp185) <= 0.001f) ? tanhf(0.5f * (fTemp184 + fVec2[1])) : (std::log(std::min<float>(3.4028235e+38f, coshf(fTemp184))) - std::log(std::min<float>(3.4028235e+38f, coshf(fVec2[1])))) / fTemp185) - fConst15 * (fConst16 * fRec1[2] + fConst17 * fRec1[1]);
			iRec40[0] = (iVec0[1] + iRec40[1]) % iSlow14;
			int iTemp186 = iRec40[0] <= iRec40[1];
			iVec3[0] = iTemp186;
			fVec4[0] = fSlow15;
			fRec41[0] = ((iVec3[1]) ? 0.0f : fRec41[1] + std::fabs(fSlow15 - fVec4[1]));
			iRec42[0] = (iTemp186 + iRec42[1]) % 16;
			ftbl0[std::max<int>(0, std::min<int>(((iTemp186 & ((fRec41[0] > 0.0f) | iSlow16)) ? iRec42[0] : 16), 16))] = fSlow15;
			int iTemp187 = std::max<int>(0, std::min<int>(iRec42[0], 16));
			float fTemp188 = ftbl0[iTemp187];
			fVec5[0] = fSlow17;
			fRec43[0] = ((iVec3[1]) ? 0.0f : fRec43[1] + std::fabs(fSlow17 - fVec5[1]));
			itbl1[std::max<int>(0, std::min<int>(((iTemp186 & ((fRec43[0] > 0.0f) | iSlow18)) ? iRec42[0] : 16), 16))] = iSlow19;
			float fTemp189 = static_cast<float>(itbl1[iTemp187]);
			iRec46[0] = 1103515245 * iRec46[1] + 12345;
			float fTemp190 = static_cast<float>(iRec46[0]);
			float fTemp191 = (((1 - iVec0[1]) | iSlow20) ? 0.0f : fSlow21 + fRec51[1]);
			fRec51[0] = fTemp191 - std::floor(fTemp191);
			float fTemp192 = std::fmod(-(4.0f * fRec51[0]), 2.0f);
			fVec6[0] = fTemp192;
			int iTemp193 = fTemp192 > fVec6[1];
			fRec50[0] = ((iTemp193) ? 0.0f : fRec50[1] - static_cast<float>(fRec50[1] > 0.0f)) + static_cast<float>(iTemp193);
			int iTemp194 = fRec50[0] > 0.0f;
			iVec7[0] = iTemp194;
			int iTemp195 = (iVec7[1] <= 0) & (iTemp194 > 0);
			float fTemp196 = 2.3283064e-10f * fTemp190 + 0.5f;
			iRec52[0] = iRec52[1] * (1 - iTemp195) + iTemp195 * (fTemp196 < fSlow22);
			int iTemp197 = iTemp194 * iRec52[0];
			iVec8[IOTA0 & 33554431] = iTemp197;
			fRec53[0] = fSlow23 + fConst22 * fRec53[1];
			float fTemp198 = std::fabs(fConst20 * std::fmod(0.125f * fRec53[0], 2e+02f)) + 6e+01f;
			int iTemp199 = iTemp197 + iVec8[(IOTA0 - static_cast<int>(std::fabs(fTemp198))) & 33554431];
			iVec9[0] = iTemp199;
			iRec49[0] = iRec49[1] + (iTemp199 > iVec9[1]);
			int iTemp200 = iRec49[0] % 2;
			iVec10[0] = iTemp200;
			float fTemp201 = ((iTemp200 != iVec10[1]) ? ((iTemp200) ? fTemp198 : fConst20 * fRec53[0] + 1.0f) : fRec47[1] + -1.0f);
			fRec47[0] = fTemp201;
			float fTemp202 = static_cast<float>(iTemp200);
			fRec48[0] = ((fTemp201 > 0.0f) ? fRec48[1] + (fTemp202 - fRec48[1]) / fTemp201 : fTemp202);
			float fTemp203 = 9.313226e-11f * (fTemp190 * mydsp_faustpower4_f(fRec48[0]) / (3.0f * fRec53[0] + 1.0f));
			fRec54[0] = fSlow24 + fConst22 * fRec54[1];
			iRec56[0] = ((iTemp197) ? iRec55[1] : iRec56[1]);
			int iTemp204 = (iVec8[(IOTA0 - 1) & 33554431] <= 0) & (iTemp197 > 0);
			iRec57[0] = iRec57[1] * (1 - iTemp204) + iTemp204 * (fTemp196 < fSlow25);
			int iTemp205 = ((iRec56[0] % 65536 + 65536) % 65536) >= 32768;
			iRec55[0] = 2 * (static_cast<float>((iRec56[0] % 2 + 2) % 2) >= 1.0f) + ((iRec57[0]) ? ((iTemp205) ? 0 : 1) : iTemp205) + 4 * (((iRec56[0] % 4 + 4) % 4) >= 2) + 8 * (((iRec56[0] % 8 + 8) % 8) >= 4) + 16 * (((iRec56[0] % 16 + 16) % 16) >= 8) + 32 * (((iRec56[0] % 32 + 32) % 32) >= 16) + 64 * (((iRec56[0] % 64 + 64) % 64) >= 32) + 128 * (((iRec56[0] % 128 + 128) % 128) >= 64) + 256 * (((iRec56[0] % 256 + 256) % 256) >= 128) + 512 * (((iRec56[0] % 512 + 512) % 512) >= 256) + 1024 * (((iRec56[0] % 1024 + 1024) % 1024) >= 512) + 2048 * (((iRec56[0] % 2048 + 2048) % 2048) >= 1024) + 4096 * (((iRec56[0] % 4096 + 4096) % 4096) >= 2048) + 8192 * (((iRec56[0] % 8192 + 8192) % 8192) >= 4096) + 16384 * (((iRec56[0] % 16384 + 16384) % 16384) >= 8192) + 32768 * (((iRec56[0] % 32768 + 32768) % 32768) >= 16384);
			float fTemp206 = fRec54[0] * (1.5259022e-05f * static_cast<float>(2 * iRec55[0]) + 1.0f) * static_cast<float>(2 * ((iRec55[0] % 4) == 0) + 1);
			fRec59[0] = fSlow26 + 0.8f * fRec59[1];
			fRec58[0] = ((iVec3[1]) ? 0.0f : fRec58[1] + std::fabs(fRec59[0] - fRec59[1]));
			itbl2[std::max<int>(0, std::min<int>(((iTemp186 & ((fRec58[0] > 0.0f) | (fRec59[0] <= 0.0f))) ? iRec42[0] : 16), 16))] = static_cast<int>(fRec59[0]);
			float fTemp207 = static_cast<float>(itbl2[iTemp187]);
			float fTemp208 = 2.0f * fTemp207;
			float fTemp209 = std::fmod(fTemp206 * std::pow(1.0f, fTemp208), 2e+04f);
			float fTemp210 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp209)));
			float fTemp211 = 0.0045454544f * (fTemp209 / fTemp210);
			float fTemp212 = std::tan(fConst23 * ((fTemp206 < 2e+04f) ? 2.2e+02f * fTemp210 * ((fTemp211 < 1.7777778f) ? ((fTemp211 < 1.5f) ? ((fTemp211 < 1.3333334f) ? ((fTemp211 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp213 = 1.0f / fTemp212;
			fRec61[0] = fSlow27 + fConst22 * fRec61[1];
			fRec60[0] = ((iVec3[1]) ? 0.0f : fRec60[1] + std::fabs(fRec61[0] - fRec61[1]));
			ftbl3[std::max<int>(0, std::min<int>(((iTemp186 & ((fRec60[0] > 0.0f) | (fRec61[0] <= 0.2f))) ? iRec42[0] : 16), 16))] = fRec61[0];
			float fTemp214 = ftbl3[iTemp187];
			float fTemp215 = 1.0f / (8e+01f * fTemp214 + 1e+01f);
			float fTemp216 = (fTemp213 - fTemp215) / fTemp212 + 1.0f;
			float fTemp217 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp212);
			float fTemp218 = (fTemp213 + fTemp215) / fTemp212 + 1.0f;
			fRec45[0] = fTemp203 - (fRec45[2] * fTemp216 + 2.0f * fRec45[1] * fTemp217) / fTemp218;
			float fTemp219 = 5.0f * fTemp214 + 3.0f;
			fRec44[0] = ((fRec45[0] - fRec45[2]) / (fTemp219 * fTemp212) - (fTemp216 * fRec44[2] + 2.0f * fTemp217 * fRec44[1])) / fTemp218;
			float fTemp220 = (fRec44[2] + fRec44[0] + 2.0f * fRec44[1]) / fTemp219;
			fRec62[0] = (fTemp220 - (fTemp216 * fRec62[2] + 2.0f * fTemp217 * fRec62[1])) / fTemp218;
			float fTemp221 = std::fmod(fTemp206 * std::pow(3.0f, fTemp208), 2e+04f);
			float fTemp222 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp221)));
			float fTemp223 = 0.0045454544f * (fTemp221 / fTemp222);
			float fTemp224 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower2_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp222 * ((fTemp223 < 1.7777778f) ? ((fTemp223 < 1.5f) ? ((fTemp223 < 1.3333334f) ? ((fTemp223 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp225 = 1.0f / fTemp224;
			float fTemp226 = (fTemp225 - fTemp215) / fTemp224 + 1.0f;
			float fTemp227 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp224);
			float fTemp228 = (fTemp215 + fTemp225) / fTemp224 + 1.0f;
			fRec64[0] = fTemp203 - (fRec64[2] * fTemp226 + 2.0f * fRec64[1] * fTemp227) / fTemp228;
			fRec63[0] = ((fRec64[0] - fRec64[2]) / (fTemp219 * fTemp224) - (fTemp226 * fRec63[2] + 2.0f * fTemp227 * fRec63[1])) / fTemp228;
			float fTemp229 = (fRec63[2] + fRec63[0] + 2.0f * fRec63[1]) / fTemp219;
			fRec65[0] = (fTemp229 - (fTemp226 * fRec65[2] + 2.0f * fTemp227 * fRec65[1])) / fTemp228;
			float fTemp230 = std::fmod(fTemp206 * std::pow(5.0f, fTemp208), 2e+04f);
			float fTemp231 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp230)));
			float fTemp232 = 0.0045454544f * (fTemp230 / fTemp231);
			float fTemp233 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower4_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp231 * ((fTemp232 < 1.7777778f) ? ((fTemp232 < 1.5f) ? ((fTemp232 < 1.3333334f) ? ((fTemp232 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp234 = 1.0f / fTemp233;
			float fTemp235 = (fTemp234 - fTemp215) / fTemp233 + 1.0f;
			float fTemp236 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp233);
			float fTemp237 = (fTemp215 + fTemp234) / fTemp233 + 1.0f;
			fRec67[0] = fTemp203 - (fRec67[2] * fTemp235 + 2.0f * fRec67[1] * fTemp236) / fTemp237;
			fRec66[0] = ((fRec67[0] - fRec67[2]) / (fTemp219 * fTemp233) - (fTemp235 * fRec66[2] + 2.0f * fTemp236 * fRec66[1])) / fTemp237;
			float fTemp238 = (fRec66[2] + fRec66[0] + 2.0f * fRec66[1]) / fTemp219;
			fRec68[0] = (fTemp238 - (fTemp235 * fRec68[2] + 2.0f * fTemp236 * fRec68[1])) / fTemp237;
			float fTemp239 = std::fmod(fTemp206 * std::pow(7.0f, fTemp208), 2e+04f);
			float fTemp240 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp239)));
			float fTemp241 = 0.0045454544f * (fTemp239 / fTemp240);
			float fTemp242 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower6_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp240 * ((fTemp241 < 1.7777778f) ? ((fTemp241 < 1.5f) ? ((fTemp241 < 1.3333334f) ? ((fTemp241 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp243 = 1.0f / fTemp242;
			float fTemp244 = (fTemp243 - fTemp215) / fTemp242 + 1.0f;
			float fTemp245 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp242);
			float fTemp246 = (fTemp215 + fTemp243) / fTemp242 + 1.0f;
			fRec70[0] = fTemp203 - (fRec70[2] * fTemp244 + 2.0f * fRec70[1] * fTemp245) / fTemp246;
			fRec69[0] = ((fRec70[0] - fRec70[2]) / (fTemp219 * fTemp242) - (fTemp244 * fRec69[2] + 2.0f * fTemp245 * fRec69[1])) / fTemp246;
			float fTemp247 = (fRec69[2] + fRec69[0] + 2.0f * fRec69[1]) / fTemp219;
			fRec71[0] = (fTemp247 - (fTemp244 * fRec71[2] + 2.0f * fTemp245 * fRec71[1])) / fTemp246;
			float fTemp248 = std::fmod(fTemp206 * std::pow(9.0f, fTemp208), 2e+04f);
			float fTemp249 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp248)));
			float fTemp250 = 0.0045454544f * (fTemp248 / fTemp249);
			float fTemp251 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower8_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp249 * ((fTemp250 < 1.7777778f) ? ((fTemp250 < 1.5f) ? ((fTemp250 < 1.3333334f) ? ((fTemp250 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp252 = 1.0f / fTemp251;
			float fTemp253 = (fTemp252 - fTemp215) / fTemp251 + 1.0f;
			float fTemp254 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp251);
			float fTemp255 = (fTemp215 + fTemp252) / fTemp251 + 1.0f;
			fRec73[0] = fTemp203 - (fRec73[2] * fTemp253 + 2.0f * fRec73[1] * fTemp254) / fTemp255;
			fRec72[0] = ((fRec73[0] - fRec73[2]) / (fTemp219 * fTemp251) - (fTemp253 * fRec72[2] + 2.0f * fTemp254 * fRec72[1])) / fTemp255;
			float fTemp256 = (fRec72[2] + fRec72[0] + 2.0f * fRec72[1]) / fTemp219;
			fRec74[0] = (fTemp256 - (fTemp253 * fRec74[2] + 2.0f * fTemp254 * fRec74[1])) / fTemp255;
			float fTemp257 = std::fmod(fTemp206 * std::pow(11.0f, fTemp208), 2e+04f);
			float fTemp258 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp257)));
			float fTemp259 = 0.0045454544f * (fTemp257 / fTemp258);
			float fTemp260 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 1e+01f)) < 2e+04f) ? 2.2e+02f * fTemp258 * ((fTemp259 < 1.7777778f) ? ((fTemp259 < 1.5f) ? ((fTemp259 < 1.3333334f) ? ((fTemp259 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp261 = 1.0f / fTemp260;
			float fTemp262 = (fTemp261 - fTemp215) / fTemp260 + 1.0f;
			float fTemp263 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp260);
			float fTemp264 = (fTemp215 + fTemp261) / fTemp260 + 1.0f;
			fRec76[0] = fTemp203 - (fRec76[2] * fTemp262 + 2.0f * fRec76[1] * fTemp263) / fTemp264;
			fRec75[0] = ((fRec76[0] - fRec76[2]) / (fTemp219 * fTemp260) - (fTemp262 * fRec75[2] + 2.0f * fTemp263 * fRec75[1])) / fTemp264;
			float fTemp265 = (fRec75[2] + fRec75[0] + 2.0f * fRec75[1]) / fTemp219;
			fRec77[0] = (fTemp265 - (fTemp262 * fRec77[2] + 2.0f * fTemp263 * fRec77[1])) / fTemp264;
			float fTemp266 = std::fmod(fTemp206 * std::pow(13.0f, fTemp208), 2e+04f);
			float fTemp267 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp266)));
			float fTemp268 = 0.0045454544f * (fTemp266 / fTemp267);
			float fTemp269 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 12.0f)) < 2e+04f) ? 2.2e+02f * fTemp267 * ((fTemp268 < 1.7777778f) ? ((fTemp268 < 1.5f) ? ((fTemp268 < 1.3333334f) ? ((fTemp268 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp270 = 1.0f / fTemp269;
			float fTemp271 = (fTemp270 - fTemp215) / fTemp269 + 1.0f;
			float fTemp272 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp269);
			float fTemp273 = (fTemp215 + fTemp270) / fTemp269 + 1.0f;
			fRec79[0] = fTemp203 - (fRec79[2] * fTemp271 + 2.0f * fRec79[1] * fTemp272) / fTemp273;
			fRec78[0] = ((fRec79[0] - fRec79[2]) / (fTemp219 * fTemp269) - (fTemp271 * fRec78[2] + 2.0f * fTemp272 * fRec78[1])) / fTemp273;
			float fTemp274 = (fRec78[2] + fRec78[0] + 2.0f * fRec78[1]) / fTemp219;
			fRec80[0] = (fTemp274 - (fTemp271 * fRec80[2] + 2.0f * fTemp272 * fRec80[1])) / fTemp273;
			float fTemp275 = std::fmod(fTemp206 * std::pow(15.0f, fTemp208), 2e+04f);
			float fTemp276 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp275)));
			float fTemp277 = 0.0045454544f * (fTemp275 / fTemp276);
			float fTemp278 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 14.0f)) < 2e+04f) ? 2.2e+02f * fTemp276 * ((fTemp277 < 1.7777778f) ? ((fTemp277 < 1.5f) ? ((fTemp277 < 1.3333334f) ? ((fTemp277 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp279 = 1.0f / fTemp278;
			float fTemp280 = (fTemp279 - fTemp215) / fTemp278 + 1.0f;
			float fTemp281 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp278);
			float fTemp282 = (fTemp215 + fTemp279) / fTemp278 + 1.0f;
			fRec82[0] = fTemp203 - (fRec82[2] * fTemp280 + 2.0f * fRec82[1] * fTemp281) / fTemp282;
			fRec81[0] = ((fRec82[0] - fRec82[2]) / (fTemp219 * fTemp278) - (fTemp280 * fRec81[2] + 2.0f * fTemp281 * fRec81[1])) / fTemp282;
			float fTemp283 = (fRec81[2] + fRec81[0] + 2.0f * fRec81[1]) / fTemp219;
			fRec83[0] = (fTemp283 - (fTemp280 * fRec83[2] + 2.0f * fTemp281 * fRec83[1])) / fTemp282;
			float fTemp284 = std::fmod(fTemp206 * std::pow(17.0f, fTemp208), 2e+04f);
			float fTemp285 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp284)));
			float fTemp286 = 0.0045454544f * (fTemp284 / fTemp285);
			float fTemp287 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 16.0f)) < 2e+04f) ? 2.2e+02f * fTemp285 * ((fTemp286 < 1.7777778f) ? ((fTemp286 < 1.5f) ? ((fTemp286 < 1.3333334f) ? ((fTemp286 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp288 = 1.0f / fTemp287;
			float fTemp289 = (fTemp288 - fTemp215) / fTemp287 + 1.0f;
			float fTemp290 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp287);
			float fTemp291 = (fTemp215 + fTemp288) / fTemp287 + 1.0f;
			fRec85[0] = fTemp203 - (fRec85[2] * fTemp289 + 2.0f * fRec85[1] * fTemp290) / fTemp291;
			fRec84[0] = ((fRec85[0] - fRec85[2]) / (fTemp219 * fTemp287) - (fTemp289 * fRec84[2] + 2.0f * fTemp290 * fRec84[1])) / fTemp291;
			float fTemp292 = (fRec84[2] + fRec84[0] + 2.0f * fRec84[1]) / fTemp219;
			fRec86[0] = (fTemp292 - (fTemp289 * fRec86[2] + 2.0f * fTemp290 * fRec86[1])) / fTemp291;
			float fTemp293 = std::fmod(fTemp206 * std::pow(19.0f, fTemp208), 2e+04f);
			float fTemp294 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp293)));
			float fTemp295 = 0.0045454544f * (fTemp293 / fTemp294);
			float fTemp296 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 18.0f)) < 2e+04f) ? 2.2e+02f * fTemp294 * ((fTemp295 < 1.7777778f) ? ((fTemp295 < 1.5f) ? ((fTemp295 < 1.3333334f) ? ((fTemp295 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp297 = 1.0f / fTemp296;
			float fTemp298 = (fTemp297 - fTemp215) / fTemp296 + 1.0f;
			float fTemp299 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp296);
			float fTemp300 = (fTemp215 + fTemp297) / fTemp296 + 1.0f;
			fRec88[0] = fTemp203 - (fRec88[2] * fTemp298 + 2.0f * fRec88[1] * fTemp299) / fTemp300;
			fRec87[0] = ((fRec88[0] - fRec88[2]) / (fTemp219 * fTemp296) - (fTemp298 * fRec87[2] + 2.0f * fTemp299 * fRec87[1])) / fTemp300;
			float fTemp301 = (fRec87[2] + fRec87[0] + 2.0f * fRec87[1]) / fTemp219;
			fRec89[0] = (fTemp301 - (fTemp298 * fRec89[2] + 2.0f * fTemp299 * fRec89[1])) / fTemp300;
			float fTemp302 = std::fmod(fTemp206 * std::pow(21.0f, fTemp208), 2e+04f);
			float fTemp303 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp302)));
			float fTemp304 = 0.0045454544f * (fTemp302 / fTemp303);
			float fTemp305 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 2e+01f)) < 2e+04f) ? 2.2e+02f * fTemp303 * ((fTemp304 < 1.7777778f) ? ((fTemp304 < 1.5f) ? ((fTemp304 < 1.3333334f) ? ((fTemp304 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp306 = 1.0f / fTemp305;
			float fTemp307 = (fTemp306 - fTemp215) / fTemp305 + 1.0f;
			float fTemp308 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp305);
			float fTemp309 = (fTemp215 + fTemp306) / fTemp305 + 1.0f;
			fRec91[0] = fTemp203 - (fRec91[2] * fTemp307 + 2.0f * fRec91[1] * fTemp308) / fTemp309;
			fRec90[0] = ((fRec91[0] - fRec91[2]) / (fTemp219 * fTemp305) - (fTemp307 * fRec90[2] + 2.0f * fTemp308 * fRec90[1])) / fTemp309;
			float fTemp310 = (fRec90[2] + fRec90[0] + 2.0f * fRec90[1]) / fTemp219;
			fRec92[0] = (fTemp310 - (fTemp307 * fRec92[2] + 2.0f * fTemp308 * fRec92[1])) / fTemp309;
			float fTemp311 = std::fmod(fTemp206 * std::pow(23.0f, fTemp208), 2e+04f);
			float fTemp312 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp311)));
			float fTemp313 = 0.0045454544f * (fTemp311 / fTemp312);
			float fTemp314 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 22.0f)) < 2e+04f) ? 2.2e+02f * fTemp312 * ((fTemp313 < 1.7777778f) ? ((fTemp313 < 1.5f) ? ((fTemp313 < 1.3333334f) ? ((fTemp313 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp315 = 1.0f / fTemp314;
			float fTemp316 = (fTemp315 - fTemp215) / fTemp314 + 1.0f;
			float fTemp317 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp314);
			float fTemp318 = (fTemp215 + fTemp315) / fTemp314 + 1.0f;
			fRec94[0] = fTemp203 - (fRec94[2] * fTemp316 + 2.0f * fRec94[1] * fTemp317) / fTemp318;
			fRec93[0] = ((fRec94[0] - fRec94[2]) / (fTemp219 * fTemp314) - (fTemp316 * fRec93[2] + 2.0f * fTemp317 * fRec93[1])) / fTemp318;
			float fTemp319 = (fRec93[2] + fRec93[0] + 2.0f * fRec93[1]) / fTemp219;
			fRec95[0] = (fTemp319 - (fTemp316 * fRec95[2] + 2.0f * fTemp317 * fRec95[1])) / fTemp318;
			float fTemp320 = std::fmod(fTemp206 * std::pow(25.0f, fTemp208), 2e+04f);
			float fTemp321 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp320)));
			float fTemp322 = 0.0045454544f * (fTemp320 / fTemp321);
			float fTemp323 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 24.0f)) < 2e+04f) ? 2.2e+02f * fTemp321 * ((fTemp322 < 1.7777778f) ? ((fTemp322 < 1.5f) ? ((fTemp322 < 1.3333334f) ? ((fTemp322 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp324 = 1.0f / fTemp323;
			float fTemp325 = (fTemp324 - fTemp215) / fTemp323 + 1.0f;
			float fTemp326 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp323);
			float fTemp327 = (fTemp215 + fTemp324) / fTemp323 + 1.0f;
			fRec97[0] = fTemp203 - (fRec97[2] * fTemp325 + 2.0f * fRec97[1] * fTemp326) / fTemp327;
			fRec96[0] = ((fRec97[0] - fRec97[2]) / (fTemp219 * fTemp323) - (fTemp325 * fRec96[2] + 2.0f * fTemp326 * fRec96[1])) / fTemp327;
			float fTemp328 = (fRec96[2] + fRec96[0] + 2.0f * fRec96[1]) / fTemp219;
			fRec98[0] = (fTemp328 - (fTemp325 * fRec98[2] + 2.0f * fTemp326 * fRec98[1])) / fTemp327;
			float fTemp329 = std::fmod(fTemp206 * std::pow(27.0f, fTemp208), 2e+04f);
			float fTemp330 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp329)));
			float fTemp331 = 0.0045454544f * (fTemp329 / fTemp330);
			float fTemp332 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 26.0f)) < 2e+04f) ? 2.2e+02f * fTemp330 * ((fTemp331 < 1.7777778f) ? ((fTemp331 < 1.5f) ? ((fTemp331 < 1.3333334f) ? ((fTemp331 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp333 = 1.0f / fTemp332;
			float fTemp334 = (fTemp333 - fTemp215) / fTemp332 + 1.0f;
			float fTemp335 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp332);
			float fTemp336 = (fTemp215 + fTemp333) / fTemp332 + 1.0f;
			fRec100[0] = fTemp203 - (fRec100[2] * fTemp334 + 2.0f * fRec100[1] * fTemp335) / fTemp336;
			fRec99[0] = ((fRec100[0] - fRec100[2]) / (fTemp219 * fTemp332) - (fTemp334 * fRec99[2] + 2.0f * fTemp335 * fRec99[1])) / fTemp336;
			float fTemp337 = (fRec99[2] + fRec99[0] + 2.0f * fRec99[1]) / fTemp219;
			fRec101[0] = (fTemp337 - (fTemp334 * fRec101[2] + 2.0f * fTemp335 * fRec101[1])) / fTemp336;
			float fTemp338 = std::fmod(fTemp206 * std::pow(29.0f, fTemp208), 2e+04f);
			float fTemp339 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp338)));
			float fTemp340 = 0.0045454544f * (fTemp338 / fTemp339);
			float fTemp341 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 28.0f)) < 2e+04f) ? 2.2e+02f * fTemp339 * ((fTemp340 < 1.7777778f) ? ((fTemp340 < 1.5f) ? ((fTemp340 < 1.3333334f) ? ((fTemp340 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp342 = 1.0f / fTemp341;
			float fTemp343 = (fTemp342 - fTemp215) / fTemp341 + 1.0f;
			float fTemp344 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp341);
			float fTemp345 = (fTemp215 + fTemp342) / fTemp341 + 1.0f;
			fRec103[0] = fTemp203 - (fRec103[2] * fTemp343 + 2.0f * fRec103[1] * fTemp344) / fTemp345;
			fRec102[0] = ((fRec103[0] - fRec103[2]) / (fTemp219 * fTemp341) - (fTemp343 * fRec102[2] + 2.0f * fTemp344 * fRec102[1])) / fTemp345;
			float fTemp346 = (fRec102[2] + fRec102[0] + 2.0f * fRec102[1]) / fTemp219;
			fRec104[0] = (fTemp346 - (fTemp343 * fRec104[2] + 2.0f * fTemp344 * fRec104[1])) / fTemp345;
			float fTemp347 = std::fmod(fTemp206 * std::pow(31.0f, fTemp208), 2e+04f);
			float fTemp348 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp347)));
			float fTemp349 = 0.0045454544f * (fTemp347 / fTemp348);
			float fTemp350 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 3e+01f)) < 2e+04f) ? 2.2e+02f * fTemp348 * ((fTemp349 < 1.7777778f) ? ((fTemp349 < 1.5f) ? ((fTemp349 < 1.3333334f) ? ((fTemp349 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp351 = 1.0f / fTemp350;
			float fTemp352 = (fTemp351 - fTemp215) / fTemp350 + 1.0f;
			float fTemp353 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp350);
			float fTemp354 = (fTemp215 + fTemp351) / fTemp350 + 1.0f;
			fRec106[0] = fTemp203 - (fRec106[2] * fTemp352 + 2.0f * fRec106[1] * fTemp353) / fTemp354;
			fRec105[0] = ((fRec106[0] - fRec106[2]) / (fTemp219 * fTemp350) - (fTemp352 * fRec105[2] + 2.0f * fTemp353 * fRec105[1])) / fTemp354;
			float fTemp355 = (fRec105[2] + fRec105[0] + 2.0f * fRec105[1]) / fTemp219;
			fRec107[0] = (fTemp355 - (fTemp352 * fRec107[2] + 2.0f * fTemp353 * fRec107[1])) / fTemp354;
			float fTemp356 = std::fmod(fTemp206 * std::pow(2.0f, fTemp208), 2e+04f);
			float fTemp357 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp356)));
			float fTemp358 = 0.0045454544f * (fTemp356 / fTemp357);
			float fTemp359 = std::tan(fConst23 * (((2.0f * fTemp206 * fTemp207) < 2e+04f) ? 2.2e+02f * fTemp357 * ((fTemp358 < 1.7777778f) ? ((fTemp358 < 1.5f) ? ((fTemp358 < 1.3333334f) ? ((fTemp358 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp360 = 1.0f / fTemp359;
			float fTemp361 = (fTemp360 - fTemp215) / fTemp359 + 1.0f;
			float fTemp362 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp359);
			float fTemp363 = (fTemp215 + fTemp360) / fTemp359 + 1.0f;
			fRec109[0] = fTemp203 - (fRec109[2] * fTemp361 + 2.0f * fRec109[1] * fTemp362) / fTemp363;
			fRec108[0] = ((fRec109[0] - fRec109[2]) / (fTemp219 * fTemp359) - (fTemp361 * fRec108[2] + 2.0f * fTemp362 * fRec108[1])) / fTemp363;
			float fTemp364 = (fRec108[2] + fRec108[0] + 2.0f * fRec108[1]) / fTemp219;
			fRec110[0] = (fTemp364 - (fTemp361 * fRec110[2] + 2.0f * fTemp362 * fRec110[1])) / fTemp363;
			float fTemp365 = std::fmod(fTemp206 * std::pow(4.0f, fTemp208), 2e+04f);
			float fTemp366 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp365)));
			float fTemp367 = 0.0045454544f * (fTemp365 / fTemp366);
			float fTemp368 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower3_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp366 * ((fTemp367 < 1.7777778f) ? ((fTemp367 < 1.5f) ? ((fTemp367 < 1.3333334f) ? ((fTemp367 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp369 = 1.0f / fTemp368;
			float fTemp370 = (fTemp369 - fTemp215) / fTemp368 + 1.0f;
			float fTemp371 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp368);
			float fTemp372 = (fTemp215 + fTemp369) / fTemp368 + 1.0f;
			fRec112[0] = fTemp203 - (fRec112[2] * fTemp370 + 2.0f * fRec112[1] * fTemp371) / fTemp372;
			fRec111[0] = ((fRec112[0] - fRec112[2]) / (fTemp219 * fTemp368) - (fTemp370 * fRec111[2] + 2.0f * fTemp371 * fRec111[1])) / fTemp372;
			float fTemp373 = (fRec111[2] + fRec111[0] + 2.0f * fRec111[1]) / fTemp219;
			fRec113[0] = (fTemp373 - (fTemp370 * fRec113[2] + 2.0f * fTemp371 * fRec113[1])) / fTemp372;
			float fTemp374 = std::fmod(fTemp206 * std::pow(6.0f, fTemp208), 2e+04f);
			float fTemp375 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp374)));
			float fTemp376 = 0.0045454544f * (fTemp374 / fTemp375);
			float fTemp377 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower5_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp375 * ((fTemp376 < 1.7777778f) ? ((fTemp376 < 1.5f) ? ((fTemp376 < 1.3333334f) ? ((fTemp376 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp378 = 1.0f / fTemp377;
			float fTemp379 = (fTemp378 - fTemp215) / fTemp377 + 1.0f;
			float fTemp380 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp377);
			float fTemp381 = (fTemp215 + fTemp378) / fTemp377 + 1.0f;
			fRec115[0] = fTemp203 - (fRec115[2] * fTemp379 + 2.0f * fRec115[1] * fTemp380) / fTemp381;
			fRec114[0] = ((fRec115[0] - fRec115[2]) / (fTemp219 * fTemp377) - (fTemp379 * fRec114[2] + 2.0f * fTemp380 * fRec114[1])) / fTemp381;
			float fTemp382 = (fRec114[2] + fRec114[0] + 2.0f * fRec114[1]) / fTemp219;
			fRec116[0] = (fTemp382 - (fTemp379 * fRec116[2] + 2.0f * fTemp380 * fRec116[1])) / fTemp381;
			float fTemp383 = std::fmod(fTemp206 * std::pow(8.0f, fTemp208), 2e+04f);
			float fTemp384 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp383)));
			float fTemp385 = 0.0045454544f * (fTemp383 / fTemp384);
			float fTemp386 = std::tan(fConst23 * (((fTemp206 * mydsp_faustpower7_f(fTemp208)) < 2e+04f) ? 2.2e+02f * fTemp384 * ((fTemp385 < 1.7777778f) ? ((fTemp385 < 1.5f) ? ((fTemp385 < 1.3333334f) ? ((fTemp385 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp387 = 1.0f / fTemp386;
			float fTemp388 = (fTemp387 - fTemp215) / fTemp386 + 1.0f;
			float fTemp389 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp386);
			float fTemp390 = (fTemp215 + fTemp387) / fTemp386 + 1.0f;
			fRec118[0] = fTemp203 - (fRec118[2] * fTemp388 + 2.0f * fRec118[1] * fTemp389) / fTemp390;
			fRec117[0] = ((fRec118[0] - fRec118[2]) / (fTemp219 * fTemp386) - (fTemp388 * fRec117[2] + 2.0f * fTemp389 * fRec117[1])) / fTemp390;
			float fTemp391 = (fRec117[2] + fRec117[0] + 2.0f * fRec117[1]) / fTemp219;
			fRec119[0] = (fTemp391 - (fTemp388 * fRec119[2] + 2.0f * fTemp389 * fRec119[1])) / fTemp390;
			float fTemp392 = std::fmod(fTemp206 * std::pow(1e+01f, fTemp208), 2e+04f);
			float fTemp393 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp392)));
			float fTemp394 = 0.0045454544f * (fTemp392 / fTemp393);
			float fTemp395 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 9.0f)) < 2e+04f) ? 2.2e+02f * fTemp393 * ((fTemp394 < 1.7777778f) ? ((fTemp394 < 1.5f) ? ((fTemp394 < 1.3333334f) ? ((fTemp394 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp396 = 1.0f / fTemp395;
			float fTemp397 = (fTemp396 - fTemp215) / fTemp395 + 1.0f;
			float fTemp398 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp395);
			float fTemp399 = (fTemp215 + fTemp396) / fTemp395 + 1.0f;
			fRec121[0] = fTemp203 - (fRec121[2] * fTemp397 + 2.0f * fRec121[1] * fTemp398) / fTemp399;
			fRec120[0] = ((fRec121[0] - fRec121[2]) / (fTemp219 * fTemp395) - (fTemp397 * fRec120[2] + 2.0f * fTemp398 * fRec120[1])) / fTemp399;
			float fTemp400 = (fRec120[2] + fRec120[0] + 2.0f * fRec120[1]) / fTemp219;
			fRec122[0] = (fTemp400 - (fTemp397 * fRec122[2] + 2.0f * fTemp398 * fRec122[1])) / fTemp399;
			float fTemp401 = std::fmod(fTemp206 * std::pow(12.0f, fTemp208), 2e+04f);
			float fTemp402 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp401)));
			float fTemp403 = 0.0045454544f * (fTemp401 / fTemp402);
			float fTemp404 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 11.0f)) < 2e+04f) ? 2.2e+02f * fTemp402 * ((fTemp403 < 1.7777778f) ? ((fTemp403 < 1.5f) ? ((fTemp403 < 1.3333334f) ? ((fTemp403 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp405 = 1.0f / fTemp404;
			float fTemp406 = (fTemp405 - fTemp215) / fTemp404 + 1.0f;
			float fTemp407 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp404);
			float fTemp408 = (fTemp215 + fTemp405) / fTemp404 + 1.0f;
			fRec124[0] = fTemp203 - (fRec124[2] * fTemp406 + 2.0f * fRec124[1] * fTemp407) / fTemp408;
			fRec123[0] = ((fRec124[0] - fRec124[2]) / (fTemp219 * fTemp404) - (fTemp406 * fRec123[2] + 2.0f * fTemp407 * fRec123[1])) / fTemp408;
			float fTemp409 = (fRec123[2] + fRec123[0] + 2.0f * fRec123[1]) / fTemp219;
			fRec125[0] = (fTemp409 - (fTemp406 * fRec125[2] + 2.0f * fTemp407 * fRec125[1])) / fTemp408;
			float fTemp410 = std::fmod(fTemp206 * std::pow(14.0f, fTemp208), 2e+04f);
			float fTemp411 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp410)));
			float fTemp412 = 0.0045454544f * (fTemp410 / fTemp411);
			float fTemp413 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 13.0f)) < 2e+04f) ? 2.2e+02f * fTemp411 * ((fTemp412 < 1.7777778f) ? ((fTemp412 < 1.5f) ? ((fTemp412 < 1.3333334f) ? ((fTemp412 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp414 = 1.0f / fTemp413;
			float fTemp415 = (fTemp414 - fTemp215) / fTemp413 + 1.0f;
			float fTemp416 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp413);
			float fTemp417 = (fTemp215 + fTemp414) / fTemp413 + 1.0f;
			fRec127[0] = fTemp203 - (fRec127[2] * fTemp415 + 2.0f * fRec127[1] * fTemp416) / fTemp417;
			fRec126[0] = ((fRec127[0] - fRec127[2]) / (fTemp219 * fTemp413) - (fTemp415 * fRec126[2] + 2.0f * fTemp416 * fRec126[1])) / fTemp417;
			float fTemp418 = (fRec126[2] + fRec126[0] + 2.0f * fRec126[1]) / fTemp219;
			fRec128[0] = (fTemp418 - (fTemp415 * fRec128[2] + 2.0f * fTemp416 * fRec128[1])) / fTemp417;
			float fTemp419 = std::fmod(fTemp206 * std::pow(16.0f, fTemp208), 2e+04f);
			float fTemp420 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp419)));
			float fTemp421 = 0.0045454544f * (fTemp419 / fTemp420);
			float fTemp422 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 15.0f)) < 2e+04f) ? 2.2e+02f * fTemp420 * ((fTemp421 < 1.7777778f) ? ((fTemp421 < 1.5f) ? ((fTemp421 < 1.3333334f) ? ((fTemp421 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp423 = 1.0f / fTemp422;
			float fTemp424 = (fTemp423 - fTemp215) / fTemp422 + 1.0f;
			float fTemp425 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp422);
			float fTemp426 = (fTemp215 + fTemp423) / fTemp422 + 1.0f;
			fRec130[0] = fTemp203 - (fRec130[2] * fTemp424 + 2.0f * fRec130[1] * fTemp425) / fTemp426;
			fRec129[0] = ((fRec130[0] - fRec130[2]) / (fTemp219 * fTemp422) - (fTemp424 * fRec129[2] + 2.0f * fTemp425 * fRec129[1])) / fTemp426;
			float fTemp427 = (fRec129[2] + fRec129[0] + 2.0f * fRec129[1]) / fTemp219;
			fRec131[0] = (fTemp427 - (fTemp424 * fRec131[2] + 2.0f * fTemp425 * fRec131[1])) / fTemp426;
			float fTemp428 = std::fmod(fTemp206 * std::pow(18.0f, fTemp208), 2e+04f);
			float fTemp429 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp428)));
			float fTemp430 = 0.0045454544f * (fTemp428 / fTemp429);
			float fTemp431 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 17.0f)) < 2e+04f) ? 2.2e+02f * fTemp429 * ((fTemp430 < 1.7777778f) ? ((fTemp430 < 1.5f) ? ((fTemp430 < 1.3333334f) ? ((fTemp430 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp432 = 1.0f / fTemp431;
			float fTemp433 = (fTemp432 - fTemp215) / fTemp431 + 1.0f;
			float fTemp434 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp431);
			float fTemp435 = (fTemp215 + fTemp432) / fTemp431 + 1.0f;
			fRec133[0] = fTemp203 - (fRec133[2] * fTemp433 + 2.0f * fRec133[1] * fTemp434) / fTemp435;
			fRec132[0] = ((fRec133[0] - fRec133[2]) / (fTemp219 * fTemp431) - (fTemp433 * fRec132[2] + 2.0f * fTemp434 * fRec132[1])) / fTemp435;
			float fTemp436 = (fRec132[2] + fRec132[0] + 2.0f * fRec132[1]) / fTemp219;
			fRec134[0] = (fTemp436 - (fTemp433 * fRec134[2] + 2.0f * fTemp434 * fRec134[1])) / fTemp435;
			float fTemp437 = std::fmod(fTemp206 * std::pow(2e+01f, fTemp208), 2e+04f);
			float fTemp438 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp437)));
			float fTemp439 = 0.0045454544f * (fTemp437 / fTemp438);
			float fTemp440 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 19.0f)) < 2e+04f) ? 2.2e+02f * fTemp438 * ((fTemp439 < 1.7777778f) ? ((fTemp439 < 1.5f) ? ((fTemp439 < 1.3333334f) ? ((fTemp439 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp441 = 1.0f / fTemp440;
			float fTemp442 = (fTemp441 - fTemp215) / fTemp440 + 1.0f;
			float fTemp443 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp440);
			float fTemp444 = (fTemp215 + fTemp441) / fTemp440 + 1.0f;
			fRec136[0] = fTemp203 - (fRec136[2] * fTemp442 + 2.0f * fRec136[1] * fTemp443) / fTemp444;
			fRec135[0] = ((fRec136[0] - fRec136[2]) / (fTemp219 * fTemp440) - (fTemp442 * fRec135[2] + 2.0f * fTemp443 * fRec135[1])) / fTemp444;
			float fTemp445 = (fRec135[2] + fRec135[0] + 2.0f * fRec135[1]) / fTemp219;
			fRec137[0] = (fTemp445 - (fTemp442 * fRec137[2] + 2.0f * fTemp443 * fRec137[1])) / fTemp444;
			float fTemp446 = std::fmod(fTemp206 * std::pow(22.0f, fTemp208), 2e+04f);
			float fTemp447 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp446)));
			float fTemp448 = 0.0045454544f * (fTemp446 / fTemp447);
			float fTemp449 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 21.0f)) < 2e+04f) ? 2.2e+02f * fTemp447 * ((fTemp448 < 1.7777778f) ? ((fTemp448 < 1.5f) ? ((fTemp448 < 1.3333334f) ? ((fTemp448 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp450 = 1.0f / fTemp449;
			float fTemp451 = (fTemp450 - fTemp215) / fTemp449 + 1.0f;
			float fTemp452 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp449);
			float fTemp453 = (fTemp215 + fTemp450) / fTemp449 + 1.0f;
			fRec139[0] = fTemp203 - (fRec139[2] * fTemp451 + 2.0f * fRec139[1] * fTemp452) / fTemp453;
			fRec138[0] = ((fRec139[0] - fRec139[2]) / (fTemp219 * fTemp449) - (fTemp451 * fRec138[2] + 2.0f * fTemp452 * fRec138[1])) / fTemp453;
			float fTemp454 = (fRec138[2] + fRec138[0] + 2.0f * fRec138[1]) / fTemp219;
			fRec140[0] = (fTemp454 - (fTemp451 * fRec140[2] + 2.0f * fTemp452 * fRec140[1])) / fTemp453;
			float fTemp455 = std::fmod(fTemp206 * std::pow(24.0f, fTemp208), 2e+04f);
			float fTemp456 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp455)));
			float fTemp457 = 0.0045454544f * (fTemp455 / fTemp456);
			float fTemp458 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 23.0f)) < 2e+04f) ? 2.2e+02f * fTemp456 * ((fTemp457 < 1.7777778f) ? ((fTemp457 < 1.5f) ? ((fTemp457 < 1.3333334f) ? ((fTemp457 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp459 = 1.0f / fTemp458;
			float fTemp460 = (fTemp459 - fTemp215) / fTemp458 + 1.0f;
			float fTemp461 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp458);
			float fTemp462 = (fTemp215 + fTemp459) / fTemp458 + 1.0f;
			fRec142[0] = fTemp203 - (fRec142[2] * fTemp460 + 2.0f * fRec142[1] * fTemp461) / fTemp462;
			fRec141[0] = ((fRec142[0] - fRec142[2]) / (fTemp219 * fTemp458) - (fTemp460 * fRec141[2] + 2.0f * fTemp461 * fRec141[1])) / fTemp462;
			float fTemp463 = (fRec141[2] + fRec141[0] + 2.0f * fRec141[1]) / fTemp219;
			fRec143[0] = (fTemp463 - (fTemp460 * fRec143[2] + 2.0f * fTemp461 * fRec143[1])) / fTemp462;
			float fTemp464 = std::fmod(fTemp206 * std::pow(26.0f, fTemp208), 2e+04f);
			float fTemp465 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp464)));
			float fTemp466 = 0.0045454544f * (fTemp464 / fTemp465);
			float fTemp467 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 25.0f)) < 2e+04f) ? 2.2e+02f * fTemp465 * ((fTemp466 < 1.7777778f) ? ((fTemp466 < 1.5f) ? ((fTemp466 < 1.3333334f) ? ((fTemp466 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp468 = 1.0f / fTemp467;
			float fTemp469 = (fTemp468 - fTemp215) / fTemp467 + 1.0f;
			float fTemp470 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp467);
			float fTemp471 = (fTemp215 + fTemp468) / fTemp467 + 1.0f;
			fRec145[0] = fTemp203 - (fRec145[2] * fTemp469 + 2.0f * fRec145[1] * fTemp470) / fTemp471;
			fRec144[0] = ((fRec145[0] - fRec145[2]) / (fTemp219 * fTemp467) - (fTemp469 * fRec144[2] + 2.0f * fTemp470 * fRec144[1])) / fTemp471;
			float fTemp472 = (fRec144[2] + fRec144[0] + 2.0f * fRec144[1]) / fTemp219;
			fRec146[0] = (fTemp472 - (fTemp469 * fRec146[2] + 2.0f * fTemp470 * fRec146[1])) / fTemp471;
			float fTemp473 = std::fmod(fTemp206 * std::pow(28.0f, fTemp208), 2e+04f);
			float fTemp474 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp473)));
			float fTemp475 = 0.0045454544f * (fTemp473 / fTemp474);
			float fTemp476 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 27.0f)) < 2e+04f) ? 2.2e+02f * fTemp474 * ((fTemp475 < 1.7777778f) ? ((fTemp475 < 1.5f) ? ((fTemp475 < 1.3333334f) ? ((fTemp475 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp477 = 1.0f / fTemp476;
			float fTemp478 = (fTemp477 - fTemp215) / fTemp476 + 1.0f;
			float fTemp479 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp476);
			float fTemp480 = (fTemp215 + fTemp477) / fTemp476 + 1.0f;
			fRec148[0] = fTemp203 - (fRec148[2] * fTemp478 + 2.0f * fRec148[1] * fTemp479) / fTemp480;
			fRec147[0] = ((fRec148[0] - fRec148[2]) / (fTemp219 * fTemp476) - (fTemp478 * fRec147[2] + 2.0f * fTemp479 * fRec147[1])) / fTemp480;
			float fTemp481 = (fRec147[2] + fRec147[0] + 2.0f * fRec147[1]) / fTemp219;
			fRec149[0] = (fTemp481 - (fTemp478 * fRec149[2] + 2.0f * fTemp479 * fRec149[1])) / fTemp480;
			float fTemp482 = std::fmod(fTemp206 * std::pow(3e+01f, fTemp208), 2e+04f);
			float fTemp483 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp482)));
			float fTemp484 = 0.0045454544f * (fTemp482 / fTemp483);
			float fTemp485 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 29.0f)) < 2e+04f) ? 2.2e+02f * fTemp483 * ((fTemp484 < 1.7777778f) ? ((fTemp484 < 1.5f) ? ((fTemp484 < 1.3333334f) ? ((fTemp484 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp486 = 1.0f / fTemp485;
			float fTemp487 = (fTemp486 - fTemp215) / fTemp485 + 1.0f;
			float fTemp488 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp485);
			float fTemp489 = (fTemp215 + fTemp486) / fTemp485 + 1.0f;
			fRec151[0] = fTemp203 - (fRec151[2] * fTemp487 + 2.0f * fRec151[1] * fTemp488) / fTemp489;
			fRec150[0] = ((fRec151[0] - fRec151[2]) / (fTemp219 * fTemp485) - (fTemp487 * fRec150[2] + 2.0f * fTemp488 * fRec150[1])) / fTemp489;
			float fTemp490 = (fRec150[2] + fRec150[0] + 2.0f * fRec150[1]) / fTemp219;
			fRec152[0] = (fTemp490 - (fTemp487 * fRec152[2] + 2.0f * fTemp488 * fRec152[1])) / fTemp489;
			float fTemp491 = std::fmod(fTemp206 * std::pow(32.0f, fTemp208), 2e+04f);
			float fTemp492 = std::pow(2.0f, std::floor(1.442695f * std::log(0.0045454544f * fTemp491)));
			float fTemp493 = 0.0045454544f * (fTemp491 / fTemp492);
			float fTemp494 = std::tan(fConst23 * (((fTemp206 * std::pow(fTemp208, 31.0f)) < 2e+04f) ? 2.2e+02f * fTemp492 * ((fTemp493 < 1.7777778f) ? ((fTemp493 < 1.5f) ? ((fTemp493 < 1.3333334f) ? ((fTemp493 < 1.1851852f) ? 1.0f : 1.1851852f) : 1.3333334f) : 1.5f) : 1.7777778f) : 2e+04f));
			float fTemp495 = 1.0f / fTemp494;
			float fTemp496 = (fTemp495 - fTemp215) / fTemp494 + 1.0f;
			float fTemp497 = 1.0f - 1.0f / mydsp_faustpower2_f(fTemp494);
			float fTemp498 = (fTemp215 + fTemp495) / fTemp494 + 1.0f;
			fRec154[0] = fTemp203 - (fRec154[2] * fTemp496 + 2.0f * fRec154[1] * fTemp497) / fTemp498;
			fRec153[0] = ((fRec154[0] - fRec154[2]) / (fTemp219 * fTemp494) - (fTemp496 * fRec153[2] + 2.0f * fTemp497 * fRec153[1])) / fTemp498;
			float fTemp499 = (fRec153[2] + fRec153[0] + 2.0f * fRec153[1]) / fTemp219;
			fRec155[0] = (fTemp499 - (fTemp496 * fRec155[2] + 2.0f * fTemp497 * fRec155[1])) / fTemp498;
			float fTemp500 = ((fTemp188 > 0.5f) ? 2.0f * (1.0f - fTemp188) : 1.0f) * (((0.0f < fTemp189) ? (fTemp220 - (fRec62[2] + fRec62[0] + 2.0f * fRec62[1])) / (fTemp219 * fTemp218) : 0.0f) + 0.09090909f * ((2.0f < fTemp189) ? (fTemp229 - (fRec65[2] + fRec65[0] + 2.0f * fRec65[1])) / (fTemp219 * fTemp228) : 0.0f) + 0.04761905f * ((4.0f < fTemp189) ? (fTemp238 - (fRec68[2] + fRec68[0] + 2.0f * fRec68[1])) / (fTemp219 * fTemp237) : 0.0f) + 0.032258064f * ((6.0f < fTemp189) ? (fTemp247 - (fRec71[2] + fRec71[0] + 2.0f * fRec71[1])) / (fTemp219 * fTemp246) : 0.0f) + 0.024390243f * ((8.0f < fTemp189) ? (fTemp256 - (fRec74[2] + fRec74[0] + 2.0f * fRec74[1])) / (fTemp219 * fTemp255) : 0.0f) + 0.019607844f * ((1e+01f < fTemp189) ? (fTemp265 - (fRec77[2] + fRec77[0] + 2.0f * fRec77[1])) / (fTemp219 * fTemp264) : 0.0f) + 0.016393442f * ((12.0f < fTemp189) ? (fTemp274 - (fRec80[2] + fRec80[0] + 2.0f * fRec80[1])) / (fTemp219 * fTemp273) : 0.0f) + 0.014084507f * ((14.0f < fTemp189) ? (fTemp283 - (fRec83[2] + fRec83[0] + 2.0f * fRec83[1])) / (fTemp219 * fTemp282) : 0.0f) + 0.012345679f * ((16.0f < fTemp189) ? (fTemp292 - (fRec86[2] + fRec86[0] + 2.0f * fRec86[1])) / (fTemp219 * fTemp291) : 0.0f) + 0.010989011f * ((18.0f < fTemp189) ? (fTemp301 - (fRec89[2] + fRec89[0] + 2.0f * fRec89[1])) / (fTemp219 * fTemp300) : 0.0f) + 0.00990099f * ((2e+01f < fTemp189) ? (fTemp310 - (fRec92[2] + fRec92[0] + 2.0f * fRec92[1])) / (fTemp219 * fTemp309) : 0.0f) + 0.009009009f * ((22.0f < fTemp189) ? (fTemp319 - (fRec95[2] + fRec95[0] + 2.0f * fRec95[1])) / (fTemp219 * fTemp318) : 0.0f) + 0.008264462f * ((24.0f < fTemp189) ? (fTemp328 - (fRec98[2] + fRec98[0] + 2.0f * fRec98[1])) / (fTemp219 * fTemp327) : 0.0f) + 0.007633588f * ((26.0f < fTemp189) ? (fTemp337 - (fRec101[2] + fRec101[0] + 2.0f * fRec101[1])) / (fTemp219 * fTemp336) : 0.0f) + 0.0070921984f * ((28.0f < fTemp189) ? (fTemp346 - (fRec104[2] + fRec104[0] + 2.0f * fRec104[1])) / (fTemp219 * fTemp345) : 0.0f) + 0.0066225166f * ((3e+01f < fTemp189) ? (fTemp355 - (fRec107[2] + fRec107[0] + 2.0f * fRec107[1])) / (fTemp219 * fTemp354) : 0.0f)) + ((fTemp188 < 0.5f) ? 2.0f * fTemp188 : 1.0f) * (0.16666667f * ((1.0f < fTemp189) ? (fTemp364 - (fRec110[2] + fRec110[0] + 2.0f * fRec110[1])) / (fTemp219 * fTemp363) : 0.0f) + 0.0625f * ((3.0f < fTemp189) ? (fTemp373 - (fRec113[2] + fRec113[0] + 2.0f * fRec113[1])) / (fTemp219 * fTemp372) : 0.0f) + 0.03846154f * ((5.0f < fTemp189) ? (fTemp382 - (fRec116[2] + fRec116[0] + 2.0f * fRec116[1])) / (fTemp219 * fTemp381) : 0.0f) + 0.027777778f * ((7.0f < fTemp189) ? (fTemp391 - (fRec119[2] + fRec119[0] + 2.0f * fRec119[1])) / (fTemp219 * fTemp390) : 0.0f) + 0.02173913f * ((9.0f < fTemp189) ? (fTemp400 - (fRec122[2] + fRec122[0] + 2.0f * fRec122[1])) / (fTemp219 * fTemp399) : 0.0f) + 0.017857144f * ((11.0f < fTemp189) ? (fTemp409 - (fRec125[2] + fRec125[0] + 2.0f * fRec125[1])) / (fTemp219 * fTemp408) : 0.0f) + 0.015151516f * ((13.0f < fTemp189) ? (fTemp418 - (fRec128[2] + fRec128[0] + 2.0f * fRec128[1])) / (fTemp219 * fTemp417) : 0.0f) + 0.013157895f * ((15.0f < fTemp189) ? (fTemp427 - (fRec131[2] + fRec131[0] + 2.0f * fRec131[1])) / (fTemp219 * fTemp426) : 0.0f) + 0.011627907f * ((17.0f < fTemp189) ? (fTemp436 - (fRec134[2] + fRec134[0] + 2.0f * fRec134[1])) / (fTemp219 * fTemp435) : 0.0f) + 0.010416667f * ((19.0f < fTemp189) ? (fTemp445 - (fRec137[2] + fRec137[0] + 2.0f * fRec137[1])) / (fTemp219 * fTemp444) : 0.0f) + 0.009433962f * ((21.0f < fTemp189) ? (fTemp454 - (fRec140[2] + fRec140[0] + 2.0f * fRec140[1])) / (fTemp219 * fTemp453) : 0.0f) + 0.00862069f * ((23.0f < fTemp189) ? (fTemp463 - (fRec143[2] + fRec143[0] + 2.0f * fRec143[1])) / (fTemp219 * fTemp462) : 0.0f) + 0.007936508f * ((25.0f < fTemp189) ? (fTemp472 - (fRec146[2] + fRec146[0] + 2.0f * fRec146[1])) / (fTemp219 * fTemp471) : 0.0f) + 0.007352941f * ((27.0f < fTemp189) ? (fTemp481 - (fRec149[2] + fRec149[0] + 2.0f * fRec149[1])) / (fTemp219 * fTemp480) : 0.0f) + 0.006849315f * ((29.0f < fTemp189) ? (fTemp490 - (fRec152[2] + fRec152[0] + 2.0f * fRec152[1])) / (fTemp219 * fTemp489) : 0.0f) + 0.0064102565f * ((31.0f < fTemp189) ? (fTemp499 - (fRec155[2] + fRec155[0] + 2.0f * fRec155[1])) / (fTemp219 * fTemp498) : 0.0f));
			float fTemp501 = 0.5f * fTemp500;
			fRec0[IOTA0 & 4194303] = fConst5 * (fRec1[2] + (fRec1[0] - 2.0f * fRec1[1])) + fTemp501;
			float fTemp502 = fSlow28 * fTemp500;
			output0[i0] = static_cast<FAUSTFLOAT>(fSlow0 * fRec0[IOTA0 & 4194303] + fTemp502);
			fRec192[0] = fConst24 * fRec36[0] + 0.9f * fRec192[1];
			fRec191[0] = fSlow1 * fRec156[(IOTA0 - (static_cast<int>(std::min<float>(fConst10, std::max<float>(0.0f, fRec192[0] + -1.0f))) + 1)) & 4194303] - fConst9 * (fConst11 * fRec191[2] + fConst12 * fRec191[1]);
			fRec190[0] = fConst9 * (fRec191[2] + fRec191[0] + 2.0f * fRec191[1]) - fConst8 * (fConst13 * fRec190[2] + fConst12 * fRec190[1]);
			fVec11[IOTA0 & 511] = fRec190[2] + fRec190[0] + 2.0f * fRec190[1];
			float fTemp503 = 1.9990131f * fRec189[1];
			fRec189[0] = fConst8 * fVec11[(IOTA0 - static_cast<int>(std::min<float>(4e+02f, std::max<float>(0.0f, 1.5e+03f * fRec37[0])))) & 511] - fSlow6 * (fSlow7 * fRec189[2] - fTemp503);
			float fTemp504 = 1.9990131f * fRec188[1];
			fRec188[0] = fRec189[2] + fSlow6 * (fSlow7 * fRec189[0] - fTemp503) - fSlow10 * (fSlow11 * fRec188[2] - fTemp504);
			float fTemp505 = 2.0f * fTemp5 * fRec187[1];
			fRec187[0] = fRec188[2] + fSlow10 * (fSlow11 * fRec188[0] - fTemp504) - (fTemp4 * fRec187[2] - fTemp505) / fTemp7;
			float fTemp506 = 2.0f * fTemp11 * fRec186[1];
			fRec186[0] = fRec187[2] + (fRec187[0] * fTemp4 - fTemp505) / fTemp7 - (fTemp10 * fRec186[2] - fTemp506) / fTemp13;
			float fTemp507 = 2.0f * fTemp17 * fRec185[1];
			fRec185[0] = fRec186[2] + (fRec186[0] * fTemp10 - fTemp506) / fTemp13 - (fTemp16 * fRec185[2] - fTemp507) / fTemp19;
			float fTemp508 = 2.0f * fTemp23 * fRec184[1];
			fRec184[0] = fRec185[2] + (fRec185[0] * fTemp16 - fTemp507) / fTemp19 - (fTemp22 * fRec184[2] - fTemp508) / fTemp25;
			float fTemp509 = 2.0f * fTemp29 * fRec183[1];
			fRec183[0] = fRec184[2] + (fRec184[0] * fTemp22 - fTemp508) / fTemp25 - (fTemp28 * fRec183[2] - fTemp509) / fTemp31;
			float fTemp510 = 2.0f * fTemp36 * fRec182[1];
			fRec182[0] = fRec183[2] + (fRec183[0] * fTemp28 - fTemp509) / fTemp31 - (fTemp35 * fRec182[2] - fTemp510) / fTemp38;
			float fTemp511 = 2.0f * fTemp42 * fRec181[1];
			fRec181[0] = fRec182[2] + (fRec182[0] * fTemp35 - fTemp510) / fTemp38 - (fTemp41 * fRec181[2] - fTemp511) / fTemp44;
			float fTemp512 = 2.0f * fTemp48 * fRec180[1];
			fRec180[0] = fRec181[2] + (fRec181[0] * fTemp41 - fTemp511) / fTemp44 - (fTemp47 * fRec180[2] - fTemp512) / fTemp50;
			float fTemp513 = 2.0f * fTemp54 * fRec179[1];
			fRec179[0] = fRec180[2] + (fRec180[0] * fTemp47 - fTemp512) / fTemp50 - (fTemp53 * fRec179[2] - fTemp513) / fTemp56;
			float fTemp514 = 2.0f * fTemp60 * fRec178[1];
			fRec178[0] = fRec179[2] + (fRec179[0] * fTemp53 - fTemp513) / fTemp56 - (fTemp59 * fRec178[2] - fTemp514) / fTemp62;
			float fTemp515 = 2.0f * fTemp66 * fRec177[1];
			fRec177[0] = fRec178[2] + (fRec178[0] * fTemp59 - fTemp514) / fTemp62 - (fTemp65 * fRec177[2] - fTemp515) / fTemp68;
			float fTemp516 = 2.0f * fTemp73 * fRec176[1];
			fRec176[0] = fRec177[2] + (fRec177[0] * fTemp65 - fTemp515) / fTemp68 - (fTemp72 * fRec176[2] - fTemp516) / fTemp75;
			float fTemp517 = 2.0f * fTemp79 * fRec175[1];
			fRec175[0] = fRec176[2] + (fRec176[0] * fTemp72 - fTemp516) / fTemp75 - (fTemp78 * fRec175[2] - fTemp517) / fTemp81;
			float fTemp518 = 2.0f * fTemp85 * fRec174[1];
			fRec174[0] = fRec175[2] + (fRec175[0] * fTemp78 - fTemp517) / fTemp81 - (fTemp84 * fRec174[2] - fTemp518) / fTemp87;
			float fTemp519 = 2.0f * fTemp91 * fRec173[1];
			fRec173[0] = fRec174[2] + (fRec174[0] * fTemp84 - fTemp518) / fTemp87 - (fTemp90 * fRec173[2] - fTemp519) / fTemp93;
			float fTemp520 = 2.0f * fTemp97 * fRec172[1];
			fRec172[0] = fRec173[2] + (fRec173[0] * fTemp90 - fTemp519) / fTemp93 - (fTemp96 * fRec172[2] - fTemp520) / fTemp99;
			float fTemp521 = 2.0f * fTemp103 * fRec171[1];
			fRec171[0] = fRec172[2] + (fRec172[0] * fTemp96 - fTemp520) / fTemp99 - (fTemp102 * fRec171[2] - fTemp521) / fTemp105;
			float fTemp522 = 2.0f * fTemp109 * fRec170[1];
			fRec170[0] = fRec171[2] + (fRec171[0] * fTemp102 - fTemp521) / fTemp105 - (fTemp108 * fRec170[2] - fTemp522) / fTemp111;
			float fTemp523 = 2.0f * fTemp115 * fRec169[1];
			fRec169[0] = fRec170[2] + (fRec170[0] * fTemp108 - fTemp522) / fTemp111 - (fTemp114 * fRec169[2] - fTemp523) / fTemp117;
			float fTemp524 = 2.0f * fTemp121 * fRec168[1];
			fRec168[0] = fRec169[2] + (fRec169[0] * fTemp114 - fTemp523) / fTemp117 - (fTemp120 * fRec168[2] - fTemp524) / fTemp123;
			float fTemp525 = 2.0f * fTemp127 * fRec167[1];
			fRec167[0] = fRec168[2] + (fRec168[0] * fTemp120 - fTemp524) / fTemp123 - (fTemp126 * fRec167[2] - fTemp525) / fTemp129;
			float fTemp526 = 2.0f * fTemp133 * fRec166[1];
			fRec166[0] = fRec167[2] + (fRec167[0] * fTemp126 - fTemp525) / fTemp129 - (fTemp132 * fRec166[2] - fTemp526) / fTemp135;
			float fTemp527 = 2.0f * fTemp139 * fRec165[1];
			fRec165[0] = fRec166[2] + (fRec166[0] * fTemp132 - fTemp526) / fTemp135 - (fTemp138 * fRec165[2] - fTemp527) / fTemp141;
			float fTemp528 = 2.0f * fTemp145 * fRec164[1];
			fRec164[0] = fRec165[2] + (fRec165[0] * fTemp138 - fTemp527) / fTemp141 - (fTemp144 * fRec164[2] - fTemp528) / fTemp147;
			float fTemp529 = 2.0f * fTemp151 * fRec163[1];
			fRec163[0] = fRec164[2] + (fRec164[0] * fTemp144 - fTemp528) / fTemp147 - (fTemp150 * fRec163[2] - fTemp529) / fTemp153;
			float fTemp530 = 2.0f * fTemp157 * fRec162[1];
			fRec162[0] = fRec163[2] + (fRec163[0] * fTemp150 - fTemp529) / fTemp153 - (fTemp156 * fRec162[2] - fTemp530) / fTemp159;
			float fTemp531 = 2.0f * fTemp163 * fRec161[1];
			fRec161[0] = fRec162[2] + (fRec162[0] * fTemp156 - fTemp530) / fTemp159 - (fTemp162 * fRec161[2] - fTemp531) / fTemp165;
			float fTemp532 = 2.0f * fTemp169 * fRec160[1];
			fRec160[0] = fRec161[2] + (fRec161[0] * fTemp162 - fTemp531) / fTemp165 - (fTemp168 * fRec160[2] - fTemp532) / fTemp171;
			float fTemp533 = 2.0f * fTemp175 * fRec159[1];
			fRec159[0] = fRec160[2] + (fRec160[0] * fTemp168 - fTemp532) / fTemp171 - (fTemp174 * fRec159[2] - fTemp533) / fTemp177;
			float fTemp534 = 2.0f * fTemp181 * fRec158[1];
			fRec158[0] = fRec159[2] + (fRec159[0] * fTemp174 - fTemp533) / fTemp177 - (fTemp180 * fRec158[2] - fTemp534) / fTemp183;
			float fTemp535 = fRec158[2] + (fRec158[0] * fTemp180 - fTemp534) / fTemp183;
			fVec12[0] = fTemp535;
			float fTemp536 = fTemp535 - fVec12[1];
			fRec157[0] = ((std::fabs(fTemp536) <= 0.001f) ? tanhf(0.5f * (fTemp535 + fVec12[1])) : (std::log(std::min<float>(3.4028235e+38f, coshf(fTemp535))) - std::log(std::min<float>(3.4028235e+38f, coshf(fVec12[1])))) / fTemp536) - fConst15 * (fConst16 * fRec157[2] + fConst17 * fRec157[1]);
			fRec156[IOTA0 & 4194303] = fTemp501 + fConst5 * (fRec157[2] + (fRec157[0] - 2.0f * fRec157[1]));
			output1[i0] = static_cast<FAUSTFLOAT>(fTemp502 + fSlow0 * fRec156[IOTA0 & 4194303]);
			IOTA0 = IOTA0 + 1;
			iVec0[1] = iVec0[0];
			fRec36[1] = fRec36[0];
			fRec35[2] = fRec35[1];
			fRec35[1] = fRec35[0];
			fRec34[2] = fRec34[1];
			fRec34[1] = fRec34[0];
			iRec38[1] = iRec38[0];
			iRec39[1] = iRec39[0];
			fRec37[1] = fRec37[0];
			fRec33[2] = fRec33[1];
			fRec33[1] = fRec33[0];
			fRec32[2] = fRec32[1];
			fRec32[1] = fRec32[0];
			fRec31[2] = fRec31[1];
			fRec31[1] = fRec31[0];
			fRec30[2] = fRec30[1];
			fRec30[1] = fRec30[0];
			fRec29[2] = fRec29[1];
			fRec29[1] = fRec29[0];
			fRec28[2] = fRec28[1];
			fRec28[1] = fRec28[0];
			fRec27[2] = fRec27[1];
			fRec27[1] = fRec27[0];
			fRec26[2] = fRec26[1];
			fRec26[1] = fRec26[0];
			fRec25[2] = fRec25[1];
			fRec25[1] = fRec25[0];
			fRec24[2] = fRec24[1];
			fRec24[1] = fRec24[0];
			fRec23[2] = fRec23[1];
			fRec23[1] = fRec23[0];
			fRec22[2] = fRec22[1];
			fRec22[1] = fRec22[0];
			fRec21[2] = fRec21[1];
			fRec21[1] = fRec21[0];
			fRec20[2] = fRec20[1];
			fRec20[1] = fRec20[0];
			fRec19[2] = fRec19[1];
			fRec19[1] = fRec19[0];
			fRec18[2] = fRec18[1];
			fRec18[1] = fRec18[0];
			fRec17[2] = fRec17[1];
			fRec17[1] = fRec17[0];
			fRec16[2] = fRec16[1];
			fRec16[1] = fRec16[0];
			fRec15[2] = fRec15[1];
			fRec15[1] = fRec15[0];
			fRec14[2] = fRec14[1];
			fRec14[1] = fRec14[0];
			fRec13[2] = fRec13[1];
			fRec13[1] = fRec13[0];
			fRec12[2] = fRec12[1];
			fRec12[1] = fRec12[0];
			fRec11[2] = fRec11[1];
			fRec11[1] = fRec11[0];
			fRec10[2] = fRec10[1];
			fRec10[1] = fRec10[0];
			fRec9[2] = fRec9[1];
			fRec9[1] = fRec9[0];
			fRec8[2] = fRec8[1];
			fRec8[1] = fRec8[0];
			fRec7[2] = fRec7[1];
			fRec7[1] = fRec7[0];
			fRec6[2] = fRec6[1];
			fRec6[1] = fRec6[0];
			fRec5[2] = fRec5[1];
			fRec5[1] = fRec5[0];
			fRec4[2] = fRec4[1];
			fRec4[1] = fRec4[0];
			fRec3[2] = fRec3[1];
			fRec3[1] = fRec3[0];
			fRec2[2] = fRec2[1];
			fRec2[1] = fRec2[0];
			fVec2[1] = fVec2[0];
			fRec1[2] = fRec1[1];
			fRec1[1] = fRec1[0];
			iRec40[1] = iRec40[0];
			iVec3[1] = iVec3[0];
			fVec4[1] = fVec4[0];
			fRec41[1] = fRec41[0];
			iRec42[1] = iRec42[0];
			fVec5[1] = fVec5[0];
			fRec43[1] = fRec43[0];
			iRec46[1] = iRec46[0];
			fRec51[1] = fRec51[0];
			fVec6[1] = fVec6[0];
			fRec50[1] = fRec50[0];
			iVec7[1] = iVec7[0];
			iRec52[1] = iRec52[0];
			fRec53[1] = fRec53[0];
			iVec9[1] = iVec9[0];
			iRec49[1] = iRec49[0];
			iVec10[1] = iVec10[0];
			fRec47[1] = fRec47[0];
			fRec48[1] = fRec48[0];
			fRec54[1] = fRec54[0];
			iRec56[1] = iRec56[0];
			iRec57[1] = iRec57[0];
			iRec55[1] = iRec55[0];
			fRec59[1] = fRec59[0];
			fRec58[1] = fRec58[0];
			fRec61[1] = fRec61[0];
			fRec60[1] = fRec60[0];
			fRec45[2] = fRec45[1];
			fRec45[1] = fRec45[0];
			fRec44[2] = fRec44[1];
			fRec44[1] = fRec44[0];
			fRec62[2] = fRec62[1];
			fRec62[1] = fRec62[0];
			fRec64[2] = fRec64[1];
			fRec64[1] = fRec64[0];
			fRec63[2] = fRec63[1];
			fRec63[1] = fRec63[0];
			fRec65[2] = fRec65[1];
			fRec65[1] = fRec65[0];
			fRec67[2] = fRec67[1];
			fRec67[1] = fRec67[0];
			fRec66[2] = fRec66[1];
			fRec66[1] = fRec66[0];
			fRec68[2] = fRec68[1];
			fRec68[1] = fRec68[0];
			fRec70[2] = fRec70[1];
			fRec70[1] = fRec70[0];
			fRec69[2] = fRec69[1];
			fRec69[1] = fRec69[0];
			fRec71[2] = fRec71[1];
			fRec71[1] = fRec71[0];
			fRec73[2] = fRec73[1];
			fRec73[1] = fRec73[0];
			fRec72[2] = fRec72[1];
			fRec72[1] = fRec72[0];
			fRec74[2] = fRec74[1];
			fRec74[1] = fRec74[0];
			fRec76[2] = fRec76[1];
			fRec76[1] = fRec76[0];
			fRec75[2] = fRec75[1];
			fRec75[1] = fRec75[0];
			fRec77[2] = fRec77[1];
			fRec77[1] = fRec77[0];
			fRec79[2] = fRec79[1];
			fRec79[1] = fRec79[0];
			fRec78[2] = fRec78[1];
			fRec78[1] = fRec78[0];
			fRec80[2] = fRec80[1];
			fRec80[1] = fRec80[0];
			fRec82[2] = fRec82[1];
			fRec82[1] = fRec82[0];
			fRec81[2] = fRec81[1];
			fRec81[1] = fRec81[0];
			fRec83[2] = fRec83[1];
			fRec83[1] = fRec83[0];
			fRec85[2] = fRec85[1];
			fRec85[1] = fRec85[0];
			fRec84[2] = fRec84[1];
			fRec84[1] = fRec84[0];
			fRec86[2] = fRec86[1];
			fRec86[1] = fRec86[0];
			fRec88[2] = fRec88[1];
			fRec88[1] = fRec88[0];
			fRec87[2] = fRec87[1];
			fRec87[1] = fRec87[0];
			fRec89[2] = fRec89[1];
			fRec89[1] = fRec89[0];
			fRec91[2] = fRec91[1];
			fRec91[1] = fRec91[0];
			fRec90[2] = fRec90[1];
			fRec90[1] = fRec90[0];
			fRec92[2] = fRec92[1];
			fRec92[1] = fRec92[0];
			fRec94[2] = fRec94[1];
			fRec94[1] = fRec94[0];
			fRec93[2] = fRec93[1];
			fRec93[1] = fRec93[0];
			fRec95[2] = fRec95[1];
			fRec95[1] = fRec95[0];
			fRec97[2] = fRec97[1];
			fRec97[1] = fRec97[0];
			fRec96[2] = fRec96[1];
			fRec96[1] = fRec96[0];
			fRec98[2] = fRec98[1];
			fRec98[1] = fRec98[0];
			fRec100[2] = fRec100[1];
			fRec100[1] = fRec100[0];
			fRec99[2] = fRec99[1];
			fRec99[1] = fRec99[0];
			fRec101[2] = fRec101[1];
			fRec101[1] = fRec101[0];
			fRec103[2] = fRec103[1];
			fRec103[1] = fRec103[0];
			fRec102[2] = fRec102[1];
			fRec102[1] = fRec102[0];
			fRec104[2] = fRec104[1];
			fRec104[1] = fRec104[0];
			fRec106[2] = fRec106[1];
			fRec106[1] = fRec106[0];
			fRec105[2] = fRec105[1];
			fRec105[1] = fRec105[0];
			fRec107[2] = fRec107[1];
			fRec107[1] = fRec107[0];
			fRec109[2] = fRec109[1];
			fRec109[1] = fRec109[0];
			fRec108[2] = fRec108[1];
			fRec108[1] = fRec108[0];
			fRec110[2] = fRec110[1];
			fRec110[1] = fRec110[0];
			fRec112[2] = fRec112[1];
			fRec112[1] = fRec112[0];
			fRec111[2] = fRec111[1];
			fRec111[1] = fRec111[0];
			fRec113[2] = fRec113[1];
			fRec113[1] = fRec113[0];
			fRec115[2] = fRec115[1];
			fRec115[1] = fRec115[0];
			fRec114[2] = fRec114[1];
			fRec114[1] = fRec114[0];
			fRec116[2] = fRec116[1];
			fRec116[1] = fRec116[0];
			fRec118[2] = fRec118[1];
			fRec118[1] = fRec118[0];
			fRec117[2] = fRec117[1];
			fRec117[1] = fRec117[0];
			fRec119[2] = fRec119[1];
			fRec119[1] = fRec119[0];
			fRec121[2] = fRec121[1];
			fRec121[1] = fRec121[0];
			fRec120[2] = fRec120[1];
			fRec120[1] = fRec120[0];
			fRec122[2] = fRec122[1];
			fRec122[1] = fRec122[0];
			fRec124[2] = fRec124[1];
			fRec124[1] = fRec124[0];
			fRec123[2] = fRec123[1];
			fRec123[1] = fRec123[0];
			fRec125[2] = fRec125[1];
			fRec125[1] = fRec125[0];
			fRec127[2] = fRec127[1];
			fRec127[1] = fRec127[0];
			fRec126[2] = fRec126[1];
			fRec126[1] = fRec126[0];
			fRec128[2] = fRec128[1];
			fRec128[1] = fRec128[0];
			fRec130[2] = fRec130[1];
			fRec130[1] = fRec130[0];
			fRec129[2] = fRec129[1];
			fRec129[1] = fRec129[0];
			fRec131[2] = fRec131[1];
			fRec131[1] = fRec131[0];
			fRec133[2] = fRec133[1];
			fRec133[1] = fRec133[0];
			fRec132[2] = fRec132[1];
			fRec132[1] = fRec132[0];
			fRec134[2] = fRec134[1];
			fRec134[1] = fRec134[0];
			fRec136[2] = fRec136[1];
			fRec136[1] = fRec136[0];
			fRec135[2] = fRec135[1];
			fRec135[1] = fRec135[0];
			fRec137[2] = fRec137[1];
			fRec137[1] = fRec137[0];
			fRec139[2] = fRec139[1];
			fRec139[1] = fRec139[0];
			fRec138[2] = fRec138[1];
			fRec138[1] = fRec138[0];
			fRec140[2] = fRec140[1];
			fRec140[1] = fRec140[0];
			fRec142[2] = fRec142[1];
			fRec142[1] = fRec142[0];
			fRec141[2] = fRec141[1];
			fRec141[1] = fRec141[0];
			fRec143[2] = fRec143[1];
			fRec143[1] = fRec143[0];
			fRec145[2] = fRec145[1];
			fRec145[1] = fRec145[0];
			fRec144[2] = fRec144[1];
			fRec144[1] = fRec144[0];
			fRec146[2] = fRec146[1];
			fRec146[1] = fRec146[0];
			fRec148[2] = fRec148[1];
			fRec148[1] = fRec148[0];
			fRec147[2] = fRec147[1];
			fRec147[1] = fRec147[0];
			fRec149[2] = fRec149[1];
			fRec149[1] = fRec149[0];
			fRec151[2] = fRec151[1];
			fRec151[1] = fRec151[0];
			fRec150[2] = fRec150[1];
			fRec150[1] = fRec150[0];
			fRec152[2] = fRec152[1];
			fRec152[1] = fRec152[0];
			fRec154[2] = fRec154[1];
			fRec154[1] = fRec154[0];
			fRec153[2] = fRec153[1];
			fRec153[1] = fRec153[0];
			fRec155[2] = fRec155[1];
			fRec155[1] = fRec155[0];
			fRec192[1] = fRec192[0];
			fRec191[2] = fRec191[1];
			fRec191[1] = fRec191[0];
			fRec190[2] = fRec190[1];
			fRec190[1] = fRec190[0];
			fRec189[2] = fRec189[1];
			fRec189[1] = fRec189[0];
			fRec188[2] = fRec188[1];
			fRec188[1] = fRec188[0];
			fRec187[2] = fRec187[1];
			fRec187[1] = fRec187[0];
			fRec186[2] = fRec186[1];
			fRec186[1] = fRec186[0];
			fRec185[2] = fRec185[1];
			fRec185[1] = fRec185[0];
			fRec184[2] = fRec184[1];
			fRec184[1] = fRec184[0];
			fRec183[2] = fRec183[1];
			fRec183[1] = fRec183[0];
			fRec182[2] = fRec182[1];
			fRec182[1] = fRec182[0];
			fRec181[2] = fRec181[1];
			fRec181[1] = fRec181[0];
			fRec180[2] = fRec180[1];
			fRec180[1] = fRec180[0];
			fRec179[2] = fRec179[1];
			fRec179[1] = fRec179[0];
			fRec178[2] = fRec178[1];
			fRec178[1] = fRec178[0];
			fRec177[2] = fRec177[1];
			fRec177[1] = fRec177[0];
			fRec176[2] = fRec176[1];
			fRec176[1] = fRec176[0];
			fRec175[2] = fRec175[1];
			fRec175[1] = fRec175[0];
			fRec174[2] = fRec174[1];
			fRec174[1] = fRec174[0];
			fRec173[2] = fRec173[1];
			fRec173[1] = fRec173[0];
			fRec172[2] = fRec172[1];
			fRec172[1] = fRec172[0];
			fRec171[2] = fRec171[1];
			fRec171[1] = fRec171[0];
			fRec170[2] = fRec170[1];
			fRec170[1] = fRec170[0];
			fRec169[2] = fRec169[1];
			fRec169[1] = fRec169[0];
			fRec168[2] = fRec168[1];
			fRec168[1] = fRec168[0];
			fRec167[2] = fRec167[1];
			fRec167[1] = fRec167[0];
			fRec166[2] = fRec166[1];
			fRec166[1] = fRec166[0];
			fRec165[2] = fRec165[1];
			fRec165[1] = fRec165[0];
			fRec164[2] = fRec164[1];
			fRec164[1] = fRec164[0];
			fRec163[2] = fRec163[1];
			fRec163[1] = fRec163[0];
			fRec162[2] = fRec162[1];
			fRec162[1] = fRec162[0];
			fRec161[2] = fRec161[1];
			fRec161[1] = fRec161[0];
			fRec160[2] = fRec160[1];
			fRec160[1] = fRec160[0];
			fRec159[2] = fRec159[1];
			fRec159[1] = fRec159[0];
			fRec158[2] = fRec158[1];
			fRec158[1] = fRec158[0];
			fVec12[1] = fVec12[0];
			fRec157[2] = fRec157[1];
			fRec157[1] = fRec157[0];
		}
	}

};

#include <stdio.h>
#include <string>
#include "m_pd.h"

// For some reason, the first inlet has always been
// reserved for messages, so the input signals (if any)
// would only start at the *second* inlet. This is not
// very idiomatic as the first inlet can be a signal inlet
// and still take messages. Also, the message outlet
// comes before the signal outlet(s), which isn't very
// idiomatic either.
// If NEWIO is 1, incoming messages go to the first signal
// inlet and the message outlet comes last;
// if NEWIO is 0, you get the old behavior.
//
// NOTE: NEWIO=1 is not compatible yet with the faust2pd
// program which generates the UI wrapper.
#ifndef NEWIO
#define NEWIO 0
#endif

// for dlsym() resp. GetProcAddress()
#ifdef _WIN32
# include <windows.h>
#else
# include <dlfcn.h>
#endif

#define sym(name) xsym(name)
#define xsym(name) #name
#define faust_setup(name) xfaust_setup(name)
#define xfaust_setup(name) name ## _tilde_setup(void)
#define classname(x) class_getname(*(t_pd *)x)

// time for "active" toggle xfades in secs
#define XFADE_TIME 0.1f

#ifdef CLASS_MULTICHANNEL
# define HAVE_MULTICHANNEL
#else
# pragma message("building without multi-channel support; requires Pd 0.54 or later")
# define CLASS_MULTICHANNEL 0
#endif

// function pointer to signal_setmultiout API function;
// NULL if the runtime Pd version has no multichannel support.
using t_signal_setmultiout = void (*)(t_signal **, int);
static t_signal_setmultiout g_signal_setmultiout;

static t_class *faust_class;

struct t_faust {
    t_object x_obj;
    mydsp *dsp;
    PdUI *ui;
    std::string *label;
    bool active;
    bool multi;
    int xfade;
    int n_xfade;
    int rate;
    int n_in;
    int n_out;
    t_sample **inputs;
    t_sample **outputs;
    t_sample **buf;
    t_sample *dummy;
    t_outlet *out;
    t_sample f;
};

static t_symbol *s_button, *s_checkbox, *s_vslider, *s_hslider, *s_nentry,
*s_vbargraph, *s_hbargraph;

static inline void zero_samples(int k, int n, t_sample **out)
{
    for (int i = 0; i < k; i++)
#ifdef __STDC_IEC_559__
        /* IEC 559 a.k.a. IEEE 754 floats can be initialized faster like this */
        memset(out[i], 0, n*sizeof(t_sample));
#else
    for (int j = 0; j < n; j++)
        out[i][j] = 0.0f;
#endif
}

static inline void copy_samples(int k, int n, t_sample **out, t_sample **in)
{
    for (int i = 0; i < k; i++)
        memcpy(out[i], in[i], n*sizeof(t_sample));
}

static t_int *faust_perform(t_int *w)
{
    t_faust *x = (t_faust *)(w[1]);
    int n = (int)(w[2]);
    if (!x->dsp || !x->buf) return (w+3);
    AVOIDDENORMALS;
    if (x->xfade > 0) {
        float d = 1.0f/x->n_xfade, f = (x->xfade--)*d;
        d = d/n;
        x->dsp->compute(n, x->inputs, x->buf);
        if (x->active) {
            if (x->n_in == x->n_out) {
                /* xfade inputs -> buf */
                for (int j = 0; j < n; j++, f -= d) {
                    for (int i = 0; i < x->n_out; i++) {
                        x->outputs[i][j] = f*x->inputs[i][j]+(1.0f-f)*x->buf[i][j];
                    }
                }
            } else {
                /* xfade 0 -> buf */
                for (int j = 0; j < n; j++, f -= d) {
                    for (int i = 0; i < x->n_out; i++) {
                        x->outputs[i][j] = (1.0f-f)*x->buf[i][j];
                    }
                }
            }
        } else {
            if (x->n_in == x->n_out) {
                /* xfade buf -> inputs */
                for (int j = 0; j < n; j++, f -= d) {
                    for (int i = 0; i < x->n_out; i++) {
                        x->outputs[i][j] = f*x->buf[i][j]+(1.0f-f)*x->inputs[i][j];
                    }
                }
            } else {
                /* xfade buf -> 0 */
                for (int j = 0; j < n; j++, f -= d) {
                    for (int i = 0; i < x->n_out; i++) {
                        x->outputs[i][j] = f*x->buf[i][j];
                    }
                }
            }
        }
    } else if (x->active) {
        x->dsp->compute(n, x->inputs, x->buf);
        copy_samples(x->n_out, n, x->outputs, x->buf);
    } else if (x->n_in == x->n_out) {
        copy_samples(x->n_out, n, x->buf, x->inputs);
        copy_samples(x->n_out, n, x->outputs, x->buf);
    } else {
        zero_samples(x->n_out, n, x->outputs);
    }
    return (w+3);
}

static void faust_dsp(t_faust *x, t_signal **sp)
{
    int n = sp[0]->s_n, sr = (int)sp[0]->s_sr;
    if (sr != x->rate) {
        /* update sample rate */
        PdUI *ui = x->ui;
        float *z = NULL;
        if (ui->nelems > 0 &&
            (z = (float*)malloc(ui->nelems*sizeof(float)))) {
            /* save the current control values */
            for (int i = 0; i < ui->nelems; i++)
                if (ui->elems[i].zone)
                    z[i] = *ui->elems[i].zone;
        }
        /* set the proper sample rate; this requires reinitializing the dsp */
        x->rate = sr;
        x->dsp->init(sr);
        if (z) {
            /* restore previous control values */
            for (int i = 0; i < ui->nelems; i++)
                if (ui->elems[i].zone)
                    *ui->elems[i].zone = z[i];
            free(z);
        }
    }
    if (n > 0)
        x->n_xfade = (int)(x->rate*XFADE_TIME/n);

    if (x->multi && x->n_in > 0) {
        /* dummy buffer for missing input channels in multichannel mode */
        if (x->dummy)
            free(x->dummy);
        x->dummy = (t_sample*)malloc(n*sizeof(t_sample));
        memset(x->dummy, 0, n*sizeof(t_sample)); /* silence! */
    }

    if (x->buf != NULL) {
        /* temporary output buffers */
        for (int i = 0; i < x->n_out; i++) {
            if (x->buf[i])
                free(x->buf[i]);
            x->buf[i] = (t_sample*)malloc(n*sizeof(t_sample));
        }
    }

#ifdef HAVE_MULTICHANNEL
    /* NB: 's_nchans' only exists if PD_HAVE_MULTICHANNEL is defined */
    if (g_signal_setmultiout) {
        /* first set up output signals. NB: since this is a multi-channel
         * class, we need to call signal_setmultiout() on all outputs
         * - even in single-channel mode! */
        if (x->multi) {
            g_signal_setmultiout(&sp[1], x->n_out);
        } else {
            for (int i = 0; i < x->n_out; ++i) {
                g_signal_setmultiout(&sp[x->n_in+i], 1);
            }
        }
    }
    /* now we can store the input and output signals */
    if (x->multi) {
        for (int i = 0; i < x->n_in; i++) {
            if (i < sp[0]->s_nchans)
                x->inputs[i] = sp[0]->s_vec + (i*n);
            else
                x->inputs[i] = x->dummy;
        }
        for (int i = 0; i < x->n_out; i++)
            x->outputs[i] = sp[1]->s_vec + (i*n);
    } else
#endif
    {
        for (int i = 0; i < x->n_in; i++)
            x->inputs[i] = sp[i]->s_vec;
        for (int i = 0; i < x->n_out; i++)
            x->outputs[i] = sp[x->n_in+i]->s_vec;
    }

    dsp_add(faust_perform, 2, x, (t_int)n);
}

static int pathcmp(const char *s, const char *t)
{
    int n = strlen(s), m = strlen(t);
    if (n == 0 || m == 0)
        return 0;
    else if (t[0] == '/')
        return strcmp(s, t);
    else if (n <= m || s[n-m-1] != '/')
        return strcmp(s+1, t);
    else
        return strcmp(s+n-m, t);
}

static void faust_any(t_faust *x, t_symbol *s, int argc, t_atom *argv)
{
    if (!x->dsp) return;
    PdUI *ui = x->ui;
    if (s == &s_bang) {
        for (int i = 0; i < ui->nelems; i++) {
            if (ui->elems[i].label && ui->elems[i].zone) {
                t_atom args[6];
                t_symbol *_s;
                switch (ui->elems[i].type) {
                    case UI_BUTTON:
                        _s = s_button;
                        break;
                    case UI_CHECK_BUTTON:
                        _s = s_checkbox;
                        break;
                    case UI_V_SLIDER:
                        _s = s_vslider;
                        break;
                    case UI_H_SLIDER:
                        _s = s_hslider;
                        break;
                    case UI_NUM_ENTRY:
                        _s = s_nentry;
                        break;
                    case UI_V_BARGRAPH:
                        _s = s_vbargraph;
                        break;
                    case UI_H_BARGRAPH:
                        _s = s_hbargraph;
                        break;
                    default:
                        continue;
                }
                SETSYMBOL(&args[0], gensym(ui->elems[i].label));
                SETFLOAT(&args[1], *ui->elems[i].zone);
                SETFLOAT(&args[2], ui->elems[i].init);
                SETFLOAT(&args[3], ui->elems[i].min);
                SETFLOAT(&args[4], ui->elems[i].max);
                SETFLOAT(&args[5], ui->elems[i].step);
                outlet_anything(x->out, _s, 6, args);
            }
        }
    } else {
        const char *label = s->s_name;
        int count = 0;
        for (int i = 0; i < ui->nelems; i++) {
            if (ui->elems[i].label &&
                pathcmp(ui->elems[i].label, label) == 0) {
                if (argc == 0) {
                    if (ui->elems[i].zone) {
                        t_atom arg;
                        SETFLOAT(&arg, *ui->elems[i].zone);
                        outlet_anything(x->out, gensym(ui->elems[i].label), 1, &arg);
                    }
                    ++count;
                } else if (argc == 1 && argv[0].a_type == A_FLOAT &&
                           ui->elems[i].zone) {
                    float f = atom_getfloat(argv);
                    *ui->elems[i].zone = f;
                    ++count;
                } else
                    pd_error(x, "[faust] %s: bad control argument: %s",
                             x->label->c_str(), label);
            }
        }
        if (count == 0 && strcmp(label, "active") == 0) {
            if (argc == 0) {
                t_atom arg;
                SETFLOAT(&arg, (float)x->active);
                outlet_anything(x->out, gensym((char*)"active"), 1, &arg);
            } else if (argc == 1 && argv[0].a_type == A_FLOAT) {
                float f = atom_getfloat(argv);
                x->active = f != 0;
                x->xfade = x->n_xfade;
            }
        }
    }
}

static void faust_free(t_faust *x)
{
    if (x->label) delete x->label;
    if (x->dsp) delete x->dsp;
    if (x->ui) delete x->ui;
    if (x->inputs) free(x->inputs);
    if (x->outputs) free(x->outputs);
    if (x->buf) {
        for (int i = 0; i < x->n_out; i++)
            if (x->buf[i]) free(x->buf[i]);
        free(x->buf);
    }
    if (x->dummy) free(x->dummy);
}

static void *faust_new(t_symbol *s, int argc, t_atom *argv)
{
    t_faust *x = (t_faust*)pd_new(faust_class);
    int sr = -1;
    t_symbol *id = NULL;
    x->active = true;
    x->multi = false;
    // flags
    while (argc && (argv->a_type == A_SYMBOL)) {
        const char *flag = argv->a_w.w_symbol->s_name;
        if (*flag == '-') {
            if (!strcmp(flag, "-m")) {
                x->multi = true;
                argc--; argv++;
            } else {
                pd_error(x, "%s: ignore unknown flag '%s",
                    classname(x), flag);
            }
            argc--; argv++;
        } else break;
    }
    // sr|id
    // NB: we keep this code for backwards compatibility.
    // 'sr' doesn't really do anything because faust_dsp() will
    // always update the DSP to the actual samplerate.
    for (int i = 0; i < argc; i++) {
        if (argv[i].a_type == A_FLOAT)
            sr = (int)argv[i].a_w.w_float;
        else if (argv[i].a_type == A_SYMBOL)
            id = argv[i].a_w.w_symbol;
    }
    if (sr <= 0) sr = 44100;
    x->rate = sr;
    x->xfade = 0;
    x->n_xfade = (int)(sr*XFADE_TIME/64);
    x->inputs = x->outputs = x->buf = NULL;
    x->dummy = NULL;
    x->label = new std::string(sym(mydsp) "~");
    x->dsp = new mydsp();
    x->ui = new PdUI(sym(mydsp), id?id->s_name:NULL);
    if (id) {
        *x->label += " ";
        *x->label += id->s_name;
    }
    x->n_in = x->dsp->getNumInputs();
    x->n_out = x->dsp->getNumOutputs();
    assert((x->n_in + x->n_out) > 0); /* there must be at least one signal */
    if (x->n_in > 0)
        x->inputs = (t_sample**)malloc(x->n_in*sizeof(t_sample*));
    if (x->n_out > 0) {
        x->outputs = (t_sample**)malloc(x->n_out*sizeof(t_sample*));
        x->buf = (t_sample**)malloc(x->n_out*sizeof(t_sample*));
        for (int i = 0; i < x->n_out; i++)
            x->buf[i] = NULL;
    }
    x->dsp->init(sr);
    x->dsp->buildUserInterface(x->ui);
#if !NEWIO
    /* the message outlet comes first! */
    x->out = outlet_new(&x->x_obj, 0);
#endif
    if (x->multi) {
        /* only create a single (multi-channel) signal inlet and outlet;
         * NB: if NEWIO is 1, we already have a signal inlet! */
    #if !NEWIO
        inlet_new(&x->x_obj, &x->x_obj.ob_pd, &s_signal, &s_signal);
    #endif
        outlet_new(&x->x_obj, &s_signal);
    } else {
    #if NEWIO
        /* we already have a signal inlet */
        for (int i = 1; i < x->n_in; i++)
    #else
        for (int i = 0; i < x->n_in; i++)
    #endif
            inlet_new(&x->x_obj, &x->x_obj.ob_pd, &s_signal, &s_signal);
        for (int i = 0; i < x->n_out; i++)
            outlet_new(&x->x_obj, &s_signal);
    }
#if NEWIO
    /* the message outlet comes last! */
    x->out = outlet_new(&x->x_obj, 0);
#endif
    return (void *)x;
}

extern "C" void faust_setup(mydsp)
{
#ifdef HAVE_MULTICHANNEL
    // runtime check for multichannel support:
#ifdef _WIN32
    // get a handle to the module containing the Pd API functions.
    // NB: GetModuleHandle("pd.dll") does not cover all cases.
    HMODULE module;
    int moduleflags = GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                      GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT;
    if (GetModuleHandleEx(moduleflags, (LPCSTR)&pd_typedmess, &module)) {
        g_signal_setmultiout = (t_signal_setmultiout)(void *)GetProcAddress(
            module, "signal_setmultiout");
    }
#else
    // search recursively, starting from the main program
    g_signal_setmultiout = (t_signal_setmultiout)dlsym(
        dlopen(nullptr, RTLD_NOW), "signal_setmultiout");
#endif
#endif // HAVE_MULTICHANNEL

    t_symbol *s = gensym(sym(mydsp) "~");
    int classflags = g_signal_setmultiout ? CLASS_MULTICHANNEL : 0;
    faust_class = class_new(s, (t_newmethod)faust_new, (t_method)faust_free,
        sizeof(t_faust), classflags, A_GIMME, A_NULL);
    class_addmethod(faust_class, (t_method)faust_dsp, gensym((char*)"dsp"), A_NULL);
#if NEWIO
    /* the first inlet is a signal inlet */
    CLASS_MAINSIGNALIN(faust_class, t_faust, f);
#endif
    class_addanything(faust_class, faust_any);
    s_button = gensym((char*)"button");
    s_checkbox = gensym((char*)"checkbox");
    s_vslider = gensym((char*)"vslider");
    s_hslider = gensym((char*)"hslider");
    s_nentry = gensym((char*)"nentry");
    s_vbargraph = gensym((char*)"vbargraph");
    s_hbargraph = gensym((char*)"hbargraph");
    /* force initialization of mydsp */
    mydsp dsp;
    /* give some indication that we're loaded and ready to go */
    post("[faust] %s: %d inputs, %d outputs", sym(mydsp) "~",
         dsp.getNumInputs(), dsp.getNumOutputs());
}

#endif
