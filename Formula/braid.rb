class Braid < Formula
  desc "Simple tool to help track vendor branches in a Git repository"
  homepage "https://cristibalan.github.io/braid/"
  url "https://github.com/cristibalan/braid.git",
      tag:      "v1.1.3",
      revision: "74bde1426c2a2713f8a56a879e5ff2e1e4213ad8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5ed59741b764ea43be0d8ff2848f3b006b3c95ac7f1761b85cca6c2d45d365b0" => :big_sur
    sha256 "9d48b1fa445962c1b76aeefaa9f58e1b870e0e1f1b2b51f5e3c501b1ee044cb3" => :arm64_big_sur
    sha256 "bce00e37a5002ce2f02609002ea4da1db5a55f4cbfb2d13be051ac6c2747e082" => :catalina
    sha256 "ddf8f5467d0660a4d279e4410dba27f68923ca56826b251bef6762db3497e5f4" => :mojave
  end

  depends_on "ruby" if MacOS.version <= :sierra

  on_linux do
    depends_on "ruby"

    resource "json" do
      url "https://rubygems.org/gems/json-2.1.0.gem"
      sha256 "b76fd09b881088c6c64a12721a1528f2f747a1c2ee52fab4c1f60db8af946607"
    end
  end

  resource "arrayfields" do
    url "https://rubygems.org/gems/arrayfields-4.9.2.gem"
    sha256 "1593f0bac948e24aa5e5099b7994b0fb5da69b6f29a82804ccf496bc125de4ab"
  end

  resource "chronic" do
    url "https://rubygems.org/gems/chronic-0.10.2.gem"
    sha256 "766f2fcce6ac3cc152249ed0f2b827770d3e517e2e87c5fba7ed74f4889d2dc3"
  end

  if MacOS.version <= :sierra
    resource "json" do
      url "https://rubygems.org/gems/json-2.1.0.gem"
      sha256 "b76fd09b881088c6c64a12721a1528f2f747a1c2ee52fab4c1f60db8af946607"
    end
  end

  resource "fattr" do
    url "https://rubygems.org/gems/fattr-2.3.0.gem"
    sha256 "0430a798270a7097c8c14b56387331808b8d9bb83904ba643b196c895bdf5993"
  end

  resource "main" do
    url "https://rubygems.org/gems/main-6.2.2.gem"
    sha256 "af04ee3eb4b7455eb5ab17e98ab86b0dad8b8420ad3ae605313644a4c6f49675"
  end

  resource "map" do
    url "https://rubygems.org/gems/map-6.6.0.gem"
    sha256 "153a6f384515b14085805f5839d318f9d3c9dab676f341340fa4300150373cbc"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "braid.gemspec"
    system "gem", "install", "--ignore-dependencies", "braid-#{version}.gem"
    bin.install libexec/"bin/braid"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"
    output = shell_output("#{bin}/braid add https://github.com/cristibalan/braid.git")
    assert_match "Braid: Added mirror at '", output
    assert_match "braid (", shell_output("#{bin}/braid status")
  end
end
