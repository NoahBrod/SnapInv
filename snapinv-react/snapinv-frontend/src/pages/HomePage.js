import '../App.css'
import logo from '../snapinv_logo.png'

export const HomePage = () => {
    return (
        <div className='App'>
            <header className='App-header'>
                <img src={logo} className='App-logo'/>
                <p>
                    Welcome to SnapInv!
                </p>
                <a className='App-link' target='_blank' href='profile'>Join Today</a>
            </header>
        </div>
    );
}