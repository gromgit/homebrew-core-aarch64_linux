class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      :tag      => "v1.1.2",
      :revision => "440592dc93a72c958756f38c2d3509b08327d13a"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a7607973ad62e4351d8203a656327ae133cada0a4d548788e47b5feab888791" => :catalina
    sha256 "0ab21fea8eef3b7c44937e6d55552a8430c5395a5fee6a29eae4bcafd4050061" => :mojave
    sha256 "29c7c51bee87f14e3b0a875b204ca0c09195a8459d9e11ae4f174fd837bee891" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
