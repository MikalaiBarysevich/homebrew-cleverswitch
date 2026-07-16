class Cleverswitch < Formula
  include Language::Python::Virtualenv

  desc "Synchronize Logitech Easy-Switch host switching between keyboard and mouse"
  homepage "https://github.com/MikalaiBarysevich/CleverSwitch"
  url "https://github.com/MikalaiBarysevich/CleverSwitch/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "e82c3adc5be2cafa8c7cd9c25457561d934bb6b20eea223999dbb9f24e274f05"
  license "GPL-3.0-or-later"

  # macOS-only tap: bleak's BLE notify path relies on the pyobjc/CoreBluetooth stack.
  depends_on :macos
  depends_on "hidapi"        # provides libhidapi.dylib for the ctypes binding in transport.py
  depends_on "python@3.13"

  # Runtime resources. Regenerate on a Mac with:
  #   brew update-python-resources Formula/cleverswitch.rb
  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  # Pinned to the newest 2.x: bleak 3.x switched to the uv_build backend, which
  # Homebrew can't build from source (needs Rust). 2.1.1 uses poetry-core and
  # still satisfies the app's "bleak >= 0.22" requirement.
  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b4/b1/729f7458a63758bd21716648a8abcd9a0c8f2d2e9897763c8a1a1c7fd31b/pyobjc_core-12.2.1.tar.gz"
    sha256 "7a7b9b018402342cf32bf1956366896350fbe5c0478cb3ef59778f77abed7f07"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/51/34/fbe38a204643aa4e1b91391cdce07a34da565a69171ebcad08de7438a556/pyobjc_framework_cocoa-12.2.1.tar.gz"
    sha256 "b94b37fe5730e5ae1fb0052912cd174e6ec329b0bfba4a012ae5db1014b5864b"
  end

  resource "pyobjc-framework-CoreBluetooth" do
    url "https://files.pythonhosted.org/packages/d4/91/c76f3c5e8e80c7047e43c4c05b3e6fda9a7cefad5aae85487007674c966c/pyobjc_framework_corebluetooth-12.2.1.tar.gz"
    sha256 "7dbb285295097205bebbcb11f55161e5faa02111108fb7b17536176e31971eb0"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https://files.pythonhosted.org/packages/d9/3f/561653aff3f19873457c95c053f0298da517be89fdfc0ec35115ed5b7030/pyobjc_framework_libdispatch-12.2.1.tar.gz"
    sha256 "0d24eda41c6c258135077f60d410e704bc7b5a67adcb2ca463918896c7363795"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"cleverswitch"]
    keep_alive true
    log_path var/"log/cleverswitch.log"
    error_log_path var/"log/cleverswitch.log"
  end

  test do
    assert_match "cleverswitch", shell_output("#{bin}/cleverswitch --help 2>&1", 2)
  end
end
