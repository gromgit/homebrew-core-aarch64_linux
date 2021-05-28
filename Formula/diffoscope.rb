class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/e6/17/71c397a6a1b3c1e97b6b72b4935583fc6863bf2dd5467ff482e2f43346fe/diffoscope-176.tar.gz"
  sha256 "7d62c5837cb24bb0b7290a66d6c79ef27799cc22d2f8de4badebe77570df562e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac0075bb0cafdd9f8c56826f4a2c89d121ca7736dc04e7eec0149e61485f2149"
    sha256 cellar: :any_skip_relocation, big_sur:       "865d95809b9e21e8af9648730bc157db5c15517c8ba18fcd194c0afc071a89be"
    sha256 cellar: :any_skip_relocation, catalina:      "710a47a9208fd71ca632dac2c9c59e66597aa7cb2fd59ae7980180cfac5913e7"
    sha256 cellar: :any_skip_relocation, mojave:        "ea155379881388ab64a02f2b368f8bad0fccb24dbf9a8f0e2547204ec296b65e"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.9"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/af/3f/2f1147f1ef538f282340daa6109093d46c7287699d3a10c7f359b916dc7f/libarchive-c-3.0.tar.gz"
    sha256 "6f12fa9cf0e44579e5f45bbf11aa455a930fbfdb13ea0ce3c3dfe7b9b9a452ba"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/26/60/6d45e0e7043f5a7bf15238ca451256a78d3c5fe02cd372f0ed6d888a16d5/python-magic-0.4.22.tar.gz"
    sha256 "ca884349f2c92ce830e3f498c5b7c7051fe2942c3ee4332f65213b8ebff15a62"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
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
