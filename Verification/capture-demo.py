# Usage: python3 Verification/capture-demo.py SIMULATOR_UUID iPhone|iPad BUILT_APP_PATH
import subprocess, time, signal, sys
from pathlib import Path
sim = sys.argv[1]
kind = sys.argv[2]
root = Path(__file__).resolve().parents[1] / 'Demo'
def run(*args):
    return subprocess.run(['xcrun','simctl',*args],check=True,capture_output=True,text=True)
def stop():
    subprocess.run(['xcrun','simctl','terminate',sim,'test.iosHw5'],capture_output=True)
def shot(name):
    target = root/'images'/name
    for attempt in range(40):
        run('io',sim,'screenshot',str(target))
        if target.stat().st_size > 90000:
            time.sleep(3)
            run('io',sim,'screenshot',str(target))
            print('Captured', name, flush=True)
            return
        time.sleep(3)
    raise RuntimeError('App remained on launch screen: '+name)
run('install',sim,sys.argv[3])
run('status_bar',sim,'override','--time','9:41','--batteryState','charged','--batteryLevel','100')
stop(); run('launch',sim,'test.iosHw5')
time.sleep(3)
shot('01-iphone-home.png' if kind=='iPhone' else '04-ipad-home.png')
stop(); run('launch',sim,'test.iosHw5','-reading')
time.sleep(3)
shot('02-iphone-reading.png' if kind=='iPhone' else '05-ipad-reading.png')
stop(); run('launch',sim,'test.iosHw5','-library')
time.sleep(2)
shot('03-iphone-library.png' if kind=='iPhone' else '06-ipad-library.png')
stop()
video = subprocess.Popen(['xcrun','simctl','io',sim,'recordVideo','--codec=h264','--force',str(root/f'Moonlit-{kind}-demo.mp4')],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
time.sleep(1)
run('launch',sim,'test.iosHw5','-demo')
shot('demo-start-'+kind+'.png')
time.sleep(24)
video.send_signal(signal.SIGINT)
video.communicate(timeout=30)
print(kind, 'screenshots and video complete', flush=True)
stop(); run('launch',sim,'test.iosHw5','-favorites')
time.sleep(2)
shot('07-iphone-favorites.png' if kind=='iPhone' else '08-ipad-favorites.png')
print(kind, 'persistence screenshot complete', flush=True)
