class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v1.4.1.tar.gz"
  sha256 "a250dda8788fefdb0b0b7eeff1bb44375a570cd4c6a0c501bc55612775b1578e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pilosa"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6afa5a03686836dd0683db9ba1c4fe3d2ddc1a84d260eac2898ba5016ce2de12"
  end

  # https://github.com/pilosa/pilosa/issues/2149#issuecomment-993029527
  deprecate! date: "2021-12-14", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children
    cd "src/github.com/pilosa/pilosa" do
      system "make", "build", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
      prefix.install_metafiles
    end
  end

  service do
    run [opt_bin/"pilosa", "server"]
    keep_alive true
    working_dir var
  end

  test do
    server = fork do
      exec "#{bin}/pilosa", "server"
    end
    sleep 0.5
    assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
