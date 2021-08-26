class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.16.1.tar.gz"
  sha256 "3874abf8bfd4aab46f8784678c00e6bb17a4e807208a055cf008994d153e1328"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86742919bc5f87452b66294bca52bd354e01dd6ffd88bbf2a360298f8d510e53"
    sha256 cellar: :any_skip_relocation, big_sur:       "17a503062f17365b909f048f00556d8d324b65bdf1757a9e66a009a4b1bf03d2"
    sha256 cellar: :any_skip_relocation, catalina:      "4396385b6f30dbb7ac6643cbe2aa084107435ff516e2ba171e7f426fab733a1c"
    sha256 cellar: :any_skip_relocation, mojave:        "3d8050198ef19bd6d67c6754c5aa46b01a8f8cd866408addfd4f1ec8d0b92f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6271b2cb8a473bbc803305caafc1197f164ba5bab973c11e400900846eff3351"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/elves/elvish/pull/1390
  patch do
    url "https://github.com/elves/elvish/commit/aae0174d59f1bb7c54168fc57f71d4c2b8721838.patch?full_index=1"
    sha256 "b7d04f3684e74a30883258be17a408b1201c7f7cb353d7b0e701c84c02e1b281"
  end

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
