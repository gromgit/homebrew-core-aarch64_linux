class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/43/d8/414727e63240d1807bbff8fc324faf88724092a49a21f61008a1a26fcc5f/bpytop-1.0.58.tar.gz"
  sha256 "cec670c64f6ac6b333455344f1a0db074df16eaaf866703f6abb1e2c22617acb"
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
