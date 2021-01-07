class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/ff/08/8e4e6316d1dd32f3e95cc3f55088a4a67e008ff2ead638c44fb08884432f/bpytop-1.0.57.tar.gz"
  sha256 "45c46cd475f2a7ea98a49d8b2eb785709a7f9a43a0f70fe4a8900c1c738b86e2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "66b24da4da289360b94fe46efed84f29b24135ab66a3b949b91f59713742f357" => :big_sur
    sha256 "0d19b1bebd3df8f719802b425473c9e8426838ec5cff14a2ba004df720ebbaa1" => :arm64_big_sur
    sha256 "50ab8da3ff620521c5316f230ec6682cba7ed40831528ffc150f5a2d1eae5edc" => :catalina
    sha256 "7d5450824576fb11864874abd86bd3542cd3ebb4afdf4db6845e67185cf3cb6b" => :mojave
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
