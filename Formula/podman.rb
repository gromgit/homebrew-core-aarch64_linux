class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.1.0.tar.gz"
  sha256 "b3098ef71b8f93829ad144352d7223ce4f60f7571e779be5b97fc70538250781"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "907571b39f1f3f313464a56cf67119ce6618bb23d0e8cc529ceefaf49ddb5c32" => :catalina
    sha256 "9963835ec18a459e89993626c128619301e4ba24ac0cdf8f2e454d0560d4f8bf" => :mojave
    sha256 "43fbdf788b4ec5747f632ceb33711316cf657985264d3296a57206d32712abfc" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
