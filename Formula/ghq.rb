class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.17.0",
      :revision => "bb059e45e72c30b28e38fbadbda29dca71f8d04a"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e80787a89135e7d2d866c1a76be3d7a68bc181b22bb625956866b6888acd51af" => :catalina
    sha256 "cd81762810c89e29332152218312036d9b3343a578d7397762673fe8acae394c" => :mojave
    sha256 "c5fa1e9dd36b96499d930fd0ccd9876870c65732753f7ec9f746aa53d00c64e2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
