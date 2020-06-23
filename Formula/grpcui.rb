class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.0.0.tar.gz"
  sha256 "2169f72d23a5e4caceee3b863220bf6a4b4a15f7d88d5bb0de909ca4299a92df"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    assert_match "#{host}: no such host", shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
  end
end
