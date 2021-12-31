class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/32/61/9a26b8f3dcdb5cb17daff57c9a85be6d5963d50488f45319d64a413da762/fabric-2.6.0.tar.gz"
  sha256 "47f184b070272796fd2f9f0436799e18f2ccba4ee8ee587796fca192acd46cd2"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/fabric/fabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ec9676b52ecf6b7e5e65b2a536fb1f838b02f76f5ef384ef82bc9978016aea7"
    sha256 cellar: :any,                 arm64_big_sur:  "026dc1ebdf0eed14b4d8d0c391f63374801d4c31707278b618fead6c91de97b4"
    sha256 cellar: :any,                 monterey:       "1a8b762203a27b7600ca72560847e4367e1d772944c311d3b3bf380fe47c0dc1"
    sha256 cellar: :any,                 big_sur:        "daaaa303f70742edbdc5b40d447087a33806981a727c242df9b4b6428ce03ad0"
    sha256 cellar: :any,                 catalina:       "c726617cfedbb3ce32cdbc685e052def43df3a656339e7fd85ee37e8c000bc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c696886c70249c5a417132c90cbf1187f1b9c3c23c8ec015ad77722a417ddeb"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/cc/98/8a258ab4787e6f835d350639792527d2eb7946ff9fc0caca9c3f4cf5dcfe/cryptography-3.4.8.tar.gz"
    sha256 "94cc5ed4ceaefcbe5bf38c8fba6a21fc1d365bb8fb826ea1688e3370b2e24a1c"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f0/bf/12827f26d127549b0c17aeb075b8bec2b0a48873418c51fca4bfcd0bd985/invoke-1.5.0.tar.gz"
    sha256 "f0c560075b5fb29ba14dad44a7185514e94970d1b9d57dcd3723bec5fed92650"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309/pathlib2-2.3.5.tar.gz"
    sha256 "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~EOS
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    EOS
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
