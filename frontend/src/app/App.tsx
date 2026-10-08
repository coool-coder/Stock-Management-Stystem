import { Link, Route, Routes } from 'react-router-dom';

function Dashboard() {
  return <main className="min-h-screen p-6">
    <div className="mx-auto max-w-7xl">
    <div className="mb-8">
      <p className="text-sm font-medium text-indigo-600">Inventory Management</p>
      <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
      <p className="mt-2 text-slate-600">The application foundation is ready. Inventory features will be added module by module.</p>
    </div>
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {['Products','Inventory Value','Low Stock','Warehouses'].map((label) =>
          <section key={label} className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">{label}</p><p className="mt-2 text-2xl font-bold">—</p>
          </section>)}
    </div>
    <nav className="mt-8 flex flex-wrap gap-3">
      <Link className="rounded-lg bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700" to="/products">Products</Link>
      <Link className="rounded-lg border border-slate-300 bg-white px-4 py-2 hover:bg-slate-50" to="/inventory">Inventory</Link>
    </nav>
  </div>
  </main>;
}
function Products() { return <Page title="Products" description="Product catalog will be implemented in the Product Core phase." />; }
function Inventory() { return <Page title="Inventory" description="Warehouse-level stock balances and movements will be implemented in the Inventory phase." />; }
function Page({title, description}:{title:string;description:string}) { return <main className="min-h-screen p-6"><div className="mx-auto max-w-7xl"><Link className="text-sm text-indigo-600" to="/">← Dashboard</Link><h1 className="mt-6 text-3xl font-bold">{title}</h1><p className="mt-2 text-slate-600">{description}</p></div></main>; }
export default function App() { return <Routes><Route path="/" element={<Dashboard/>}/><Route path="/products" element={<Products/>}/><Route path="/inventory" element={<Inventory/>}/></Routes>; }
