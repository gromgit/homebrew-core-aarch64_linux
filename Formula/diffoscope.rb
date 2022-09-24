class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/e1/7b/977596c2b123bc64c857f12e69ff621762cf6952547c906ba43b700e0603/diffoscope-222.tar.gz"
  sha256 "ffb90a9f6000c9b27763eb58bcdd9e3681fccec857e6807d4568680a3801098e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66741ea64dd716619d4db69eeafd5db86266eb731a256d254e0a51e4606f2f05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0d77786ab6f36226b217899197fe569919a4c0fa4b7c5b55cb9fdf2d89dacf1"
    sha256 cellar: :any_skip_relocation, monterey:       "6d9b3185b9f1d4e657171009721b0e13bdf8843bfbce04d1a715d5c62550c431"
    sha256 cellar: :any_skip_relocation, big_sur:        "79a46d8dfd2fa78974bb3023b5dd3560bcc66a19ca8b7efbbfccd46e22af1d21"
    sha256 cellar: :any_skip_relocation, catalina:       "0409eb06bd447756166426163f61a594b07d77a2699ce50c731700cfb0711455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bdb79de3f0f19ebbeeed49422191c0ee2f5b5fab61c933aa67e2ec569fc6262"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
