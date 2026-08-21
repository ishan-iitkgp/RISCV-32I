@echo off
echo ----------------------------------------
echo 🛠️ Compiling Verilog files...
iverilog -o simulation.vvp processor_tb.v ../src/*.v

:: Check if compilation was successful
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Compilation Failed! Fix syntax errors and try again.
    echo ----------------------------------------
    exit /b
)

echo ✅ Compilation Successful!
echo 🚀 Running Simulation...
vvp simulation.vvp

echo 🌊 Opening Waveform in GTKWave...
:: The 'start' command opens it in a new window so your terminal doesn't freeze
start gtkwave processor.vcd
echo ----------------------------------------