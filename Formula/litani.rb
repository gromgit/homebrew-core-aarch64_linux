class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.24.0",
      revision: "93cb710327388b69f82cc3bd897d1ad7cddb6eb4"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbdf30cfa38a3df1c9421161e744d6c8b35fb8faaaed8fdcbec4c6d0e4634fe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04b1a0a8a8a6762d913dc8daaff9f0ce52f5cbeb30c49e86ca4b78b0aafbadc7"
    sha256 cellar: :any_skip_relocation, monterey:       "ebdf855bdda3a90b644d26dcfaf10cd08c92c042a581082b39c85dddc918cba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc77d1c33f995432e4c76f73cb76c05ee49063a411aa546f9845bbdb48304448"
    sha256 cellar: :any_skip_relocation, catalina:       "32a97a63fd82f7ceb49f21ddf6012bb3183c194d722848bf287d31939471f24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631c439580bfdc411038d43a031d5f7008232dc1703463294f7a557c761a2c07"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.9"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3")
    venv.pip_install resources

    libexec.install Dir["*"] - ["test", "examples"]
    (bin/"litani").write_env_script libexec/"litani", PATH: "\"#{libexec}/vendor/bin:${PATH}\""

    cd libexec/"doc" do
      system libexec/"vendor/bin/python3", "configure"
      system "ninja", "--verbose"
    end
    man1.install libexec.glob("doc/out/man/*.1")
    man5.install libexec.glob("doc/out/man/*.5")
    man7.install libexec.glob("doc/out/man/*.7")
    doc.install libexec/"doc/out/html/index.html"
    rm_rf libexec/"doc"
  end

  test do
    system bin/"litani", "init", "--project-name", "test-installation"
    system bin/"litani", "add-job",
           "--command", "/usr/bin/true",
           "--pipeline-name", "test-installation",
           "--ci-stage", "test"
    system bin/"litani", "run-build"
  end
end
