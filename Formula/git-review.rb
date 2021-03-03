class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/54/36/445652deaa5e19a58e5512bdc8c5a37ccc9673cb205c7e06ff776cb8b228/git-review-2.0.0.tar.gz"
  sha256 "6e6c86b61334526c5c0f200fdf61957310b0c32208339a38c890db7fe0de5452"
  license "Apache-2.0"
  head "https://opendev.org/opendev/git-review.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "341a0755197859195ec1f2a8be8db5171977503cdd7c64ce15208820496ca3cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "190c3c9830ee15af21693da67676eb63fe1db783e8399f842d6adfc7097caf07"
    sha256 cellar: :any_skip_relocation, catalina:      "4503d5b3e596e408beff669df65c3761bfe39727a8f98fc89868341d47194a1f"
    sha256 cellar: :any_skip_relocation, mojave:        "804656f3cf7beeedab1fba587a3407f2718fe3d146bdcbc6c2a41863620048bc"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ecd779098abba89d86f749bdfa37f261978e6c12de928b3e5eb69e7e00a598e8"
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
  end

  def install
    virtualenv_install_with_resources
    man1.install gzip("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
