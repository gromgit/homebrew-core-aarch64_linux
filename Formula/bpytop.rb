class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/cf/18/a53f8d2393ca8856a9a3e7e6130d6803048d21e7bac60ae6979249436d25/bpytop-1.0.65.tar.gz"
  sha256 "de16412efec4bde588466bfed2166908240b59d941c48fc6b9623e2fde0e05ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a948efb8575563dfa4e58feab665989003e043602c32c780647c3ee0b1405c6c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4734b7a4876f2ce8fcab0e7e4dde25e55c574cb5054dc5b8094e499ae20e5deb"
    sha256 cellar: :any_skip_relocation, catalina:      "af52fe4d6d3ff458572a9fd39507e33ad0bad4f1fb15a6d6eb06f3e6b4965d0a"
    sha256 cellar: :any_skip_relocation, mojave:        "d0a896d093dd71505646544947c5b1b9160556764a407ea2f9fc7bee9f133192"
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
    mkdir config/"themes"
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
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
