class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.3.tar.gz"
  sha256 "c0a02276e718b988d1220dc452063759c8634d42e1c01a04c021486c1e61612d"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gotop"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "909173cc6e2c14acf65477d065b4d7466ad06320ef9f90a75617e92596123730"
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
