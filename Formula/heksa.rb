class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa.git",
      tag:      "v1.14.0",
      revision: "045ea335825556c856b2f4dee606ae91c61afe7d"
  license "Apache-2.0"
  head "https://github.com/raspi/heksa.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/heksa"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5a0861843d0325dace5e92043a5bf56795349499cf98d82b5256cc00c73b4e9a"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/heksa"
  end

  test do
    require "pty"

    r, _w, pid = PTY.spawn("#{bin}/heksa -l 16 -f asc -o no #{test_fixtures("test.png")}")

    # remove ANSI colors
    begin
      output = r.read.gsub(/\e\[([;\d]+)?m/, "")
      assert_match(/^.PNG/, output)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    Process.wait(pid)
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
