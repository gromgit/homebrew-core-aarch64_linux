class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/c0/7b/8a81267ab04c286e2f7da3b1db488f1e2af917937223589281af87a05308/bpytop-1.0.59.tar.gz"
  sha256 "bfa578e770fa8ac30e9efde23724d305c226989c29e554e8a56124ec28510124"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b2ab4c3f9cea156977a8726cca5abd14b4f4fc86e2c3bd065794d404f5ceae1" => :big_sur
    sha256 "f07ba1f67b48f2196209630f2cbc79cc3521d4ec9faabbd70cce8868038d0e06" => :arm64_big_sur
    sha256 "aa62580426adf75d08d5625660e4a8c61fb881bcaba751db9cba641da3947aee" => :catalina
    sha256 "f9be8562001269a5430c7cfde1c3d3238a9735df04c10493e3b0de29678f312e" => :mojave
  end

  depends_on "python@3.9"
  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "bpytop-themes" => "themes"
  end

  test do
    config = (testpath/".config/bpytop")
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    assert_not_match /ERROR:/, log
  ensure
    Process.kill("TERM", pid)
  end
end
