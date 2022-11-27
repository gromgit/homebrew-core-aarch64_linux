class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.4.tar.gz"
  sha256 "9fe5eb25ee253e5679cd0dede0ec6e075d6782442bc3007bb9fea8c44e66b857"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gotop"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a8960dba3c70e6686bba30e318b770a7cc58cc140313dfb8ae547de3f8fcb527"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.BuildDate=#{time.strftime("%Y%m%dT%H%M%S")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    conf_path = if OS.mac?
      "Library/Application Support/gotop/gotop.conf"
    else
      ".config/gotop/gotop.conf"
    end
    assert_predicate testpath/conf_path, :exist?
  end
end
