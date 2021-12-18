class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v12.0.2.tar.gz"
  sha256 "4d37b60cef3e2c926d916d3f0930baa1ec0988b60ecf88304198b678fedc2b46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52180f014ff32dbc114d5c21e4f81d6321e3aa8e376fb20be493a7766e9691ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "262a8fab539118debe67ce1da0487fc08931d1a5b114ca1198ab2ef2fb78ed46"
    sha256 cellar: :any_skip_relocation, monterey:       "3dcdd42f5bea4f71652b8aef8af3a9004b170eafebb4b0d7d9e95fab3c9f0601"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa01dcd962f326037eb83949ed72adfeea62c69d7820ff598560725fb85d213c"
    sha256 cellar: :any_skip_relocation, catalina:       "0898553d59618bcf3d774e48166f42e9532f8075a707d717cb2858a8d925fcc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee338aaf512028933f6c4b88c0b101b61589c97a9ce0d053475bf11d50510d1"
  end

  depends_on "go" => :build
  depends_on "etcd"

  def install
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}"
    pkgshare.install "examples"
  end

  test do
    ENV["ETCDCTL_API"] = "2"
    etcd_server = "localhost:#{free_port}"
    cell = "testcell"

    fork do
      exec Formula["etcd"].opt_bin/"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}/etcd",
                                           "--listen-client-urls=http://#{etcd_server}",
                                           "--advertise-client-urls=http://#{etcd_server}"
    end
    sleep 3

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/"global"
    end
    sleep 1

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/cell
    end
    sleep 1

    fork do
      exec bin/"vtctl", "-topo_implementation", "etcd2",
                        "-topo_global_server_address", etcd_server,
                        "-topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "-topo_implementation", "etcd2",
                         "-topo_global_server_address", etcd_server,
                         "-topo_global_root", testpath/"global",
                         "-tablet_types_to_wait", "PRIMARY,REPLICA",
                         "-cell", cell,
                         "-cells_to_watch", cell,
                         "-port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
