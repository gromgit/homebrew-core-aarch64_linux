class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/cc/d8/82aec85fc7ad0853afca2c88e73ecc7d3a50c66988c44aa9748ccbc9b689/neovim-remote-2.4.0.tar.gz"
  sha256 "f199ebb61c3decf462feed4e7d467094ed38d8afaf43620736b5983a12fe2427"
  license "MIT"
  revision 1
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0568bf3cb14f9e28c2700a629657b3f2fff0f18b0d3ff4466a8aa93f3c73898e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0d20a2667bc55a954a1e62e6f6e7e6fe32905b57d204cd7ae1f2b7f8ab69fe"
    sha256 cellar: :any_skip_relocation, monterey:       "62d48f9615d8199367d901a3ff7dab155c6dcac6a647e4095b1d7a0dd3d4c327"
    sha256 cellar: :any_skip_relocation, big_sur:        "2397e3153ca914d67937fb22329d761f6db9c391d5b2eb6dedaa20f3ba6b5b90"
    sha256 cellar: :any_skip_relocation, catalina:       "3d6ce83585c9dba3b3603c945b941ff6695fd71e41a01d2a75076b45fa9326d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec3ab6e795babba12cc2bded96c466680c99526f970f6b101568e32214fa077"
  end

  depends_on "neovim"
  depends_on "python@3.10"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/47/6d/be10df2b141fcb1020c9605f7758881b5af706fb09a05b737e8eb7540387/greenlet-1.1.0.tar.gz"
    sha256 "c87df8ae3f01ffb4483c796fe1b15232ce2b219f0b18126948616224d3f658ee"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/7a/01/2d0898ba6cefbe2736283ee3155cba1c602de641ca5667ac55a0e4857276/pynvim-0.4.3.tar.gz"
    sha256 "3a795378bde5e8092fbeb3a1a99be9c613d2685542f1db0e5c6fd467eed56dff"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    socket = testpath/"nvimsocket"
    file = testpath/"test.txt"
    ENV["NVIM_LISTEN_ADDRESS"] = socket

    nvim = spawn(
      { "NVIM_LISTEN_ADDRESS" => socket },
      Formula["neovim"].opt_bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", file,
      [:out, :err] => "/dev/null"
    )
    sleep 5

    str = "Hello from neovim-remote!"
    system bin/"nvr", "--remote-send", "i#{str}<esc>:write<cr>"
    assert_equal str, file.read.chomp
    assert_equal Process.kill(0, nvim), 1

    system bin/"nvr", "--remote-send", ":quit<cr>"

    # Test will be terminated by the timeout
    # if `:quit` was not sent correctly
    Process.wait nvim
  end
end
